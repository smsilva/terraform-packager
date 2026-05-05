# Credenciais

## Azure

### Usando Service Principal (variáveis de ambiente)

```bash
export ARM_SUBSCRIPTION_ID="..."
export ARM_TENANT_ID="..."
export ARM_CLIENT_ID="..."
export ARM_CLIENT_SECRET="..."
export ARM_STORAGE_ACCOUNT_NAME="..."
export ARM_STORAGE_ACCOUNT_CONTAINER_NAME="..."
export ARM_SAS_TOKEN="..."

stackrun azure-storage-account:latest plan
```

### Usando Azure CLI (montagem automática)

Se `ARM_CLIENT_ID` estiver vazio e os arquivos de credenciais do Azure CLI existirem no host, o `stackrun` os monta automaticamente no container:

```bash
az login
az account get-access-token > "${HOME}/.azure/access_token.json"

stackrun azure-storage-account:latest plan
```

Os arquivos montados são:

| Arquivo no host | Destino no container |
|----------------|---------------------|
| `~/.azure/access_token.json` | `/root/.azure/accessTokens.json` |
| `~/.azure/azureProfile.json` | `/root/.azure/azureProfile.json` |
| `~/.azure/msal_token_cache.json` | `/root/.azure/msal_token_cache.json` |

### Personalizar caminhos dos arquivos Azure CLI

```bash
export TF_PACKAGER_AZURE_ACCESS_TOKEN_FILE="${HOME}/.azure/access_token.json"
export TF_PACKAGER_AZURE_PROFILE_FILE="${HOME}/.azure/azureProfile.json"
export TF_PACKAGER_AZURE_MSAL_TOKEN_CACHE_FILE="${HOME}/.azure/msal_token_cache.json"
```

## AWS

```bash
export AWS_ACCESS_KEY="..."
export AWS_SECRET_KEY="..."
export AWS_DEFAULT_REGION="us-east-1"

stackrun aws-bucket:latest plan
```

## Google Cloud

```bash
export GOOGLE_CREDENTIALS="$(cat credentials.json | tr -d '\n')"
export GOOGLE_PROJECT="meu-projeto"
export GOOGLE_BUCKET="meu-bucket-state"
export GOOGLE_PREFIX="terraform"

stackrun google-bucket:latest plan
```
