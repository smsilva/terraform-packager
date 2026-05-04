# Backends suportados

O backend define onde o Terraform state é armazenado. É configurado via `terraform.backend` no `stack.yaml`.

## local

State armazenado no host, no diretório `LOCAL_TERRAFORM_OUTPUT_DIRECTORY`.

```yaml
terraform:
  backend: local
```

```bash
export LOCAL_TERRAFORM_OUTPUT_DIRECTORY="$(mktemp -d -t terraform-XXXXXXXXXX)"
export TERRAFORM_STATE_FILE="meu-projeto/terraform.state.json"
```

Arquivos gerados no diretório de saída:

```
terraform.plan
terraform.plan.json
terraform.plan.txt
plan_detailed_exitcode
<TERRAFORM_STATE_FILE>
```

## azurerm

State armazenado em Azure Blob Storage.

```yaml
terraform:
  backend: azurerm
```

Variáveis necessárias:

```bash
export ARM_STORAGE_ACCOUNT_NAME="meuStorageAccount"
export ARM_STORAGE_ACCOUNT_CONTAINER_NAME="terraform-state"
export ARM_SAS_TOKEN="..."
```

## gcs

State armazenado em Google Cloud Storage.

```yaml
terraform:
  backend: gcs
```

Variáveis necessárias:

```bash
export GOOGLE_BUCKET="meu-bucket-state"
export GOOGLE_PREFIX="terraform"
export GOOGLE_CREDENTIALS="$(cat credentials.json | tr -d '\n')"
```

## s3

State armazenado em AWS S3.

```yaml
terraform:
  backend: s3
```

Variáveis necessárias:

```bash
export AWS_BUCKET_NAME="meu-bucket-state"
export AWS_BUCKET_REGION="us-east-1"
export AWS_ACCESS_KEY="..."
export AWS_SECRET_KEY="..."
```

## Localização dos templates

Os arquivos de configuração de cada backend ficam em `templates/backend/<nome>/`:

| Arquivo | Propósito |
|---------|-----------|
| `backend.conf` | Configuração do backend para `terraform init` |
| `backend.hcl` | Fragmento HCL alternativo |
| `credentials_build.conf` | Variáveis de ambiente montadas no build |
| `credentials_run.conf` | Variáveis passadas ao container em runtime |
