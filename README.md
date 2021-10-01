# Template Go Repository

It includes:
- Continous Integration with GH Actions
  - fmt,lint and sec using Makefile targets
- Build Automation with Make
  - Build Target with appropriate flags set
  - Install Target - Install Binary to GOPATH for global access
  - Format, Lint and Gosec Targets

Things to replace:

- Makefile
  - Change `BINARY`, this is the name of the output binary
  - PKG name for providing Version Info to the specified package
  - CGO is disable, remove CGO_ENABLED from build target if you are calling some C code
- go.mod
  - Change name of the module to something like `github.com/<orgname>/<projectname>`
