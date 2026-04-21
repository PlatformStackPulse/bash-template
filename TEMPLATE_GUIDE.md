# Bash Template - Streamlined & Ready

A **slim, production-ready** Bash project template for CLI tools and automation scripts.

## Actual Project Stats

- **Shell Files**: 10 (5 lib + 2 src + 3 test files)
- **Main Codebase**: ~300 LOC (without tests)
- **Test Framework**: BATS (Bash Automated Testing System)
- **Workflows**: 6 GitHub Actions workflows
- **Dependencies**: ShellCheck, shfmt, BATS (dev only)

## Core File Structure Breakdown

```
bash-template/
├── src/
│   ├── main.sh                     # Entry point & dispatcher (~50 lines)
│   └── commands/
│       └── hello.sh                # Example command (remove/rename)
├── lib/
│   ├── logging.sh                  # Structured logging (colored, leveled)
│   ├── config.sh                   # Config loading (env vars + defaults)
│   ├── errors.sh                   # Error codes & handling
│   ├── utils.sh                    # Common utilities (validation, etc.)
│   └── version.sh                  # Version info (injected at build)
├── test/
│   ├── unit/
│   │   ├── logging_test.bats
│   │   ├── config_test.bats
│   │   ├── errors_test.bats
│   │   ├── commands_test.bats
│   │   └── utils_test.bats
│   ├── integration/
│   │   └── flow_test.bats
│   └── test_helper.bash
├── deploy/
│   └── terraform/
│       ├── main.tf
│       ├── variables.tf
│       └── terraform.dev.tfvars
├── scripts/
│   ├── build.sh                    # Bundle into single portable script
│   ├── setup-hooks.sh              # Install git hooks
│   ├── pre-commit                  # Conventional commit + lint hook
│   ├── update-changelog.sh         # Changelog generation
│   └── apply-branch-protection.sh  # GitHub branch protection
├── .github/
│   ├── workflows/                  # 6 CI/CD workflows
│   ├── actions/                    # 2 composite actions
│   ├── ISSUE_TEMPLATE/             # Bug report & feature request
│   ├── CODEOWNERS
│   └── pull_request_template.md
├── .chglog/                        # Changelog config
├── .devcontainer/                  # VS Code DevContainer
├── Makefile                        # Build automation (20+ targets)
├── Dockerfile                      # Container build
├── docker-compose.yml              # Local dev environment
├── .editorconfig                   # Editor settings
├── .gitconfig                      # Git settings
├── .gitignore
├── CHANGELOG.md
├── CONTRIBUTING.md
├── SECURITY.md
├── LICENSE                         # MIT
└── README.md
```

## Design Philosophy

**What's Included:**
- Clean project structure (lib/src/test separation)
- CLI framework (argument parsing, help, version, subcommands)
- Structured logging (colored, leveled, file logging)
- Configuration management (environment variables + defaults)
- Comprehensive testing with BATS
- Enterprise CI/CD (GitHub Actions)
- Docker support
- DevContainer support
- Static analysis (ShellCheck, shfmt)
- Git hooks & branch protection
- Conventional Commits & changelog

**What's NOT Included (Keep it Slim!):**
- No Python/Ruby/Node.js dependencies
- No bloated framework abstractions
- No unused utility functions
- Terraform/Kubernetes are optional examples only

## Customization Checklist

When creating a new project from this template:

1. [ ] Update `README.md` with your project description
2. [ ] Rename `APP_NAME` in `lib/config.sh` default
3. [ ] Rename `BINARY_NAME` in `Makefile`
4. [ ] Replace `src/commands/hello.sh` with your commands
5. [ ] Update `src/main.sh` command dispatch
6. [ ] Update `.github/CODEOWNERS`
7. [ ] Update `deploy/terraform/` for your infrastructure
8. [ ] Update `CHANGELOG.md` and `.chglog/` repository URL
9. [ ] Add your libraries to `lib/`
10. [ ] Add tests to `test/unit/` and `test/integration/`
11. [ ] Run `make all` to verify everything works

## Key Features

### 1. Library Pattern (Source, Don't Execute)

Libraries in `lib/` are **sourced**, not executed:
```bash
source "$LIB_DIR/logging.sh"
source "$LIB_DIR/config.sh"
```

Each library has a **double-source guard**:
```bash
[[ -n "${_LOGGING_SH_LOADED:-}" ]] && return 0
readonly _LOGGING_SH_LOADED=1
```

### 2. Subcommand Pattern

Commands live in `src/commands/` and are dispatched from `main.sh`:
```bash
case "$command" in
    hello)  shift; source "$SRC_DIR/commands/hello.sh"; hello_run "$@" ;;
    deploy) shift; source "$SRC_DIR/commands/deploy.sh"; deploy_run "$@" ;;
esac
```

### 3. Safe Bash Patterns

Following `set -euo pipefail` best practices:
- `if [[ test ]]; then action; fi` (not `[[ test ]] && action`)
- `var=$(( var + 1 ))` (not `((var++))`)
- `pushd/popd` (not `cd/cd -`)
- `find -print0` with `read -r -d ''`
- All variables quoted: `"$var"`

### 4. Build System

`scripts/build.sh` bundles all libraries and commands into a single portable script:
```bash
make build
# Creates: bin/bash-template (self-contained, no dependencies)
```

### 5. Testing with BATS

```bash
make test          # All tests
make test-unit     # Unit tests only
make test-integration  # Integration tests
```
