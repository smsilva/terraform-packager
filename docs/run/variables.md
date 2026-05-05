# Variáveis de ambiente

Variáveis que controlam o comportamento do `stackrun`.

## Saída

| Variável | Padrão | Descrição |
|----------|--------|-----------|
| `LOCAL_TERRAFORM_OUTPUT_DIRECTORY` | `~/trash/terraform/output` | Diretório onde o Terraform armazena arquivos de saída (plans, state) |
| `TERRAFORM_STATE_FILE` | `terraform.state` | Caminho do state file relativo a `LOCAL_TERRAFORM_OUTPUT_DIRECTORY` |

```bash
export LOCAL_TERRAFORM_OUTPUT_DIRECTORY="$(mktemp -d -t terraform-XXXXXXXXXX)"
export TERRAFORM_STATE_FILE="meu-projeto/terraform.state.json"
```

## Volumes

| Variável | Padrão | Descrição |
|----------|--------|-----------|
| `LOCAL_TERRAFORM_VARIABLES_DIRECTORY` | `$PWD` | Diretório montado em `/opt/variables/` dentro do container |
| `LOCAL_TERRAFORM_VARIABLES_DIRECTORY_EXTRA` | — | Cada arquivo do diretório é montado individualmente em `/opt/src/` |
| `LOCAL_EXTRA_VOLUMES` | — | Volumes adicionais separados por `;` no formato `-v origem:destino` |

```bash
# Montar diretório de variáveis personalizado
export LOCAL_TERRAFORM_VARIABLES_DIRECTORY="${PWD}/meus-tfvars"

# Montar arquivos extras diretamente no código fonte
export LOCAL_TERRAFORM_VARIABLES_DIRECTORY_EXTRA="${PWD}/overrides"

# Volumes adicionais
export LOCAL_EXTRA_VOLUMES="/dados/certs:/opt/certs;/dados/keys:/opt/keys"
```

## Instância

| Variável | Padrão | Descrição |
|----------|--------|-----------|
| `STACK_INSTANCE_NAME` | `default` | Identifica uma instância específica da Stack. Usado para separar state files de diferentes instâncias. |

```bash
export STACK_INSTANCE_NAME="producao"
stackrun azure-storage-account:latest apply

export STACK_INSTANCE_NAME="staging"
stackrun azure-storage-account:latest apply
```

## Debug

| Variável | Padrão | Descrição |
|----------|--------|-----------|
| `DEBUG` | `1` | Nível de verbosidade: `0` (silencioso), `1` (parâmetros), `3` (parâmetros + script gerado) |

## Variáveis TF_VAR_*

Todas as variáveis de ambiente com prefixo `TF_VAR_` são automaticamente injetadas no container:

```bash
export TF_VAR_resource_group_name="meu-grupo"
export TF_VAR_location="brazilsouth"
stackrun azure-storage-account:latest plan
```

> Variáveis de build (`TF_PACKAGER_CONTAINER_BUILDER`, `TF_PACKAGER_DOCKER_PROGRESS`, `TF_PACKAGER_TEMPORARY_BUILD_CONTEXT_DIRECTORY`) estão documentadas em [build/overview.md](../build/overview.md).
