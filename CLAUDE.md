# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Project Does

**Terraform Packager** packages Terraform code into self-contained Docker images ("Stacks"). Each image contains a specific Terraform binary version, the HCL code, and pre-downloaded providers. This follows a "build once" philosophy — the same image runs with different credentials/configurations.

## Dependencies

- `yq` — YAML parsing utility (required by build scripts)
- `Docker` (default builder) or `buildah`/`kaniko` (set via `TF_PACKAGER_CONTAINER_BUILDER`)

## Commands

### Build a stack image

```bash
scripts/stackbuild examples/azure-storage-account
```

### Run Terraform commands inside the container

```bash
scripts/stackrun azure-storage-account:latest plan
scripts/stackrun azure-storage-account:latest apply
scripts/stackrun azure-storage-account:latest destroy
scripts/stackrun azure-storage-account:latest info
```

### Debug levels

```bash
DEBUG=0 scripts/stackbuild ...   # Suppress all output
DEBUG=1 scripts/stackbuild ...   # Show parameters only (default for stackrun)
DEBUG=2 scripts/stackbuild ...   # Show parameters + builder output (default for stackbuild)
DEBUG=3 scripts/stackrun ...     # Also print the generated docker run script
```

### There are no automated tests — validation is done by building and running examples.

## Architecture

### Two-phase workflow

**Build phase** (`scripts/stackbuild <project-dir>`):
1. Reads `stack.yaml` in the project root for `name`, `terraform.version`, and `terraform.backend`
2. Detects the Terraform provider from `src/provider.tf`
3. Resolves `STACK_VERSION` from: `stack.yaml` → `cz.yaml` → latest git commit hash → `"latest"`
4. Assembles a temporary Docker build context at `~/.terraform-packager/`
5. Generates a `Dockerfile` from `templates/Dockerfile` with environment variable substitution
6. Runs `docker build` (or buildah/kaniko) producing image `{name}:{version}`

**Runtime phase** (`scripts/stackrun <image:tag> <command> [args...]`):
1. Generates a shell script at `~/.stackrun_generated.sh` containing a `docker run` command
2. Mounts output, variables, and optional credential/volume directories
3. Automatically mounts Azure CLI credential files when `ARM_CLIENT_ID` is unset and the files exist
4. Passes all `TF_VAR_*` environment variables into the container
5. The container's entrypoint runs `terraform_init` then `terraform <command>`

### Docker image stages (`templates/Dockerfile`)

| Stage | Purpose |
|---|---|
| `terraform_base_image` | Installs bash/jq, copies scripts and templates, runs `build_extra` hooks |
| `package` | Copies SSH keys, Azure creds, runs `terraform init` (downloads providers) |
| `final` | Strips build secrets; copies only `environment_variables.conf` and initialized `src/` |

### Key script files

| Script | Role |
|---|---|
| `scripts/stackbuild` | Entry point for building images |
| `scripts/stackrun` | Entry point for running containers |
| `scripts/build_setup_variables` | Parses `stack.yaml`, sets all build-time variables |
| `scripts/create_build_context` | Assembles temp build context directory |
| `scripts/build_container_image` | Invokes the selected container builder |
| `templates/scripts/entrypoint` | Container entry point, dispatches to terraform_* scripts |
| `templates/scripts/terraform_init` | Runs `terraform init` with backend configuration |

### Stack project layout

A packagable Terraform project must have:

```
<project>/
├── stack.yaml          # Required: name, terraform.version, terraform.backend
└── src/
    ├── provider.tf     # Required: provider declarations
    └── *.tf
```

Optional extensibility hooks:

```
<project>/
└── .tfp/
    └── scripts/
        ├── build/          # Scripts run during image build (e.g., install extra tools)
        └── runtime/        # Hooks: before-init, after-init, before-plan, after-plan,
                            #        before-apply, after-apply, before-destroy, after-destroy
```

### Provider and backend templates

`templates/provider/<name>/` and `templates/backend/<name>/` contain:
- `credentials_build.conf` — environment variables mounted at build time
- `credentials_run.conf` — environment variables passed at runtime
- `backend.conf` / `backend.hcl` — Terraform backend configuration fragments

### Key environment variables

| Variable | Default | Description |
|---|---|---|
| `DEBUG` | `2` (build) / `1` (run) | Output verbosity |
| `LOCAL_TERRAFORM_OUTPUT_DIRECTORY` | `~/trash/terraform/output` | Where plan/state files are written |
| `LOCAL_TERRAFORM_VARIABLES_DIRECTORY` | `$PWD` | Mounted as `/opt/variables` in container |
| `LOCAL_TERRAFORM_VARIABLES_DIRECTORY_EXTRA` | — | Files mounted individually into `/opt/src/` |
| `LOCAL_EXTRA_VOLUMES` | — | Semicolon-separated extra `-v` mounts |
| `TERRAFORM_STATE_FILE` | `terraform.state` | State file path relative to output directory |
| `TF_PACKAGER_CONTAINER_BUILDER` | `docker` | `docker`, `buildah`, or `kaniko` |
| `STACK_INSTANCE_NAME` | `default` | Identifies a specific instance of a stack |

## Versioning

Uses Commitizen (`cz.yaml`) with Conventional Commits. The current version is tracked in `cz.yaml` under `commitizen.version`. Changelog is in `CHANGELOG.md`.
