# Referência do stack.yaml

O arquivo `stack.yaml` na raiz do projeto define como a Stack será construída.

## Campos

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|-------------|-----------|
| `name` | string | sim | Nome da imagem Docker gerada |
| `version` | string | não | Versão da imagem (ver resolução automática em [build/overview.md](overview.md)) |
| `maintainer` | string | não | Autor da Stack |
| `terraform.version` | string | sim | Versão do binário Terraform |
| `terraform.backend` | string | sim | Backend para armazenar o state |

## Exemplos por backend

### Backend local

```yaml
name: local-null-resource
terraform:
  version: 1.8.5
  backend: local
```

### Backend Azure (azurerm)

```yaml
name: azure-storage-account
terraform:
  version: 1.3.9
  backend: azurerm
```

### Backend GCS (Google Cloud)

```yaml
name: google-bucket
terraform:
  version: 1.2.2
  backend: gcs
```

### Backend S3 (AWS)

```yaml
name: aws-bucket
terraform:
  version: 1.2.2
  backend: s3
```

## Como os campos são usados

- **`name`** — vira o nome da imagem Docker. `name: meu-projeto` gera `meu-projeto:{versão}`.
- **`terraform.version`** — seleciona o binário via `FROM hashicorp/terraform:{versão}`.
- **`terraform.backend`** — determina qual template de backend é usado em `templates/backend/{backend}/`.

## Resolução de versão

Se `version` for omitido ou `null`, a versão é resolvida automaticamente (ver [build/overview.md](overview.md#resolução-de-stack_version)).
