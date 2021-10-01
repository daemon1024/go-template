CURDIR=$(shell pwd)
GOPATH=$(shell go env GOPATH)
INSTALLDIR=$(GOPATH)/bin

ifeq (,$(shell which govvv))
$(shell go install github.com/ahmetb/govvv@latest)
endif

PKG := $(shell go list)
GIT_INFO := $(shell govvv -flags -pkg $(PKG))

BINARY=example # Name of binary

.PHONY: build
build:
	cd $(CURDIR)
	go mod tidy
	CGO_ENABLED=0 go build \
	-ldflags "-w -s ${GIT_INFO}"\
	-o $(BINARY)

.PHONY: install
install: build
	install -m 0755 $(BINARY) $(DESTDIR)$(INSTALLDIR)
	
.PHONY: gofmt
gofmt:
	cd $(CURDIR); test -z $(shell gofmt -s -d $(shell find . -type f -name '*.go' -print))

.PHONY: golint
golint:
ifeq (, $(shell which golangci-lint))
	@{ \
	curl -sSfL https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh | sh -s -- -b $(INSTALLDIR);\
	}
endif
	cd $(CURDIR); GOPATH=$(GOPATH) golangci-lint run -v

.PHONY: gosec
gosec:
ifeq (, $(shell which gosec))
	@{ \
	set -e ;\
	GOSEC_TMP_DIR=$$(mktemp -d) ;\
	cd $$GOSEC_TMP_DIR ;\
	go mod init tmp ;\
	go get -u github.com/securego/gosec/v2/cmd/gosec ;\
	rm -rf $$GOSEC_TMP_DIR ;\
	}
endif
	cd $(CURDIR); gosec ./...