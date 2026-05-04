# Providers suportados

## Detecção automática

O provider é detectado automaticamente a partir do arquivo `src/provider.tf`. O `stackbuild` lê as declarações `provider "..."` e seleciona o template correspondente em `templates/provider/<nome>/`.

## Providers disponíveis

| Provider | Credenciais necessárias (build e run) |
|----------|---------------------------------------|
| `aws` | `AWS_ACCESS_KEY`, `AWS_SECRET_KEY`, `AWS_DEFAULT_REGION` |
| `azurerm` | `ARM_CLIENT_ID`, `ARM_CLIENT_SECRET`, `ARM_SUBSCRIPTION_ID`, `ARM_TENANT_ID`, `ARM_STORAGE_ACCOUNT_NAME`, `ARM_STORAGE_ACCOUNT_CONTAINER_NAME`, `ARM_SAS_TOKEN` |
| `azuread` | Mesmas do `azurerm` |
| `azuredevops` | `AZDO_ORG_SERVICE_URL`, `AZDO_PERSONAL_ACCESS_TOKEN` |
| `google` | `GOOGLE_CREDENTIALS`, `GOOGLE_PROJECT` |
| `github` | `GITHUB_TOKEN` |
| `fastly` | `FASTLY_API_KEY` |
| `helm` | Configuração de kubeconfig |
| `cloudamqp` | `CLOUDAMQP_APIKEY` |
| `confluent` | `CONFLUENT_CLOUD_API_KEY`, `CONFLUENT_CLOUD_API_SECRET` |
| `hcvault` | `VAULT_ADDR`, `VAULT_TOKEN` |
| `imperva` | `IMPERVA_API_ID`, `IMPERVA_API_KEY` |
| `mongodbatlas` | `MONGODB_ATLAS_PUBLIC_KEY`, `MONGODB_ATLAS_PRIVATE_KEY` |
| `newrelic` | `NEWRELIC_API_KEY`, `NEW_RELIC_ACCOUNT_ID` |
| `rabbitmq` | `RABBITMQ_ENDPOINT`, `RABBITMQ_USERNAME`, `RABBITMQ_PASSWORD` |
| `external` | Nenhuma |
| `local` | Nenhuma |
| `null` | Nenhuma |

## Adicionar suporte a um novo provider

1. Criar o diretório `templates/provider/<nome>/`

2. Adicionar `credentials_build.conf` com as variáveis de ambiente necessárias no build:

```bash
export MINHA_CREDENCIAL="${MINHA_CREDENCIAL}"
```

3. Adicionar `credentials_run.conf` com as variáveis passadas ao container em runtime:

```bash
  -e MINHA_CREDENCIAL="${MINHA_CREDENCIAL}" \
```

4. Declarar o provider no `src/provider.tf` do projeto usando o mesmo nome do diretório:

```hcl
provider "meu-provider" {}
```
