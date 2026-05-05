---
name: terraform-packager
description: >
  Answers any question about Terraform Packager — building Stack images,
  running Terraform commands inside containers, configuring backends,
  providers, hooks, variables, and credentials. Reads docs/ files
  just-in-time based on the question.
metadata:
  version: "1.0.0"
  tags: ["terraform", "docker", "infrastructure"]
---

# Terraform Packager Skill

## Docs

The docs/ directory contains:
- `README.md` — general index
- `getting-started.md` — installation and first use
- `examples.md` — available examples
- `build/overview.md` — build phases overview
- `build/stack-yaml.md` — stack.yaml reference
- `build/hooks.md` — build hooks
- `run/overview.md` — runtime overview
- `run/commands.md` — available commands
- `run/variables.md` — environment variables
- `run/credentials.md` — credentials configuration
- `run/ssh.md` — SSH configuration
- `run/hooks.md` — runtime hooks
- `reference/backends.md` — supported backends
- `reference/providers.md` — supported providers
- `reference/templates.md` — templates reference

## Instructions

1. Identify which docs files are relevant to the question (see list above).
2. Call `read_file('path/to/file.md')` for each relevant file (e.g. `read_file('getting-started.md')` or `read_file('build/overview.md')`).
3. Synthesize a concise, accurate answer.
