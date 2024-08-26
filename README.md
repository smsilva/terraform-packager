# Terraform Packager

## Resumindo

```bash
# Google Cloud Credentials / Service Account / Bucket para armazenar o Terraform State
export GOOGLE_CREDENTIALS_FILE="${HOME}/trash/credentials.json"

if [ -e "${GOOGLE_CREDENTIALS_FILE}" ]; then

  if which jq > /dev/null; then
    GOOGLE_PROJECT=$(jq .project_id ${GOOGLE_CREDENTIALS_FILE} -r)
  else
    GOOGLE_PROJECT="$(grep project_id ${GOOGLE_CREDENTIALS_FILE} | awk -F '"' '{ print $4 }')"
  fi

  export GOOGLE_PROJECT
else
  echo "File doesn't exists: ${GOOGLE_CREDENTIALS_FILE}"
  exit 1
fi

export GOOGLE_CREDENTIALS=$(cat "${GOOGLE_CREDENTIALS_FILE}" | tr -d "\n")
export GOOGLE_BACKEND_CREDENTIALS="${GOOGLE_CREDENTIALS}"
export GOOGLE_BUCKET="silvios-wasp-foundation-k9z"
export GOOGLE_PREFIX="terraform"
export GOOGLE_CREDENTIALS_BASE64=$(        echo "${GOOGLE_CREDENTIALS}"         | base64 | tr -d "\n")
export GOOGLE_BACKEND_CREDENTIALS_BASE64=$(echo "${GOOGLE_BACKEND_CREDENTIALS}" | base64 | tr -d "\n")

# Empacotando o Projeto de Exemplo
git clone https://github.com/smsilva/terraform-packager.git
cd terraform-packager

export STACK_INSTANCE_NAME=wasp-files

# Build
env DEBUG=2 scripts/stackbuild examples/google-bucket 

# Run
env DEBUG=1 scripts/stackrun google-bucket:edge plan 
env DEBUG=1 scripts/stackrun google-bucket:edge apply
env DEBUG=0 scripts/stackrun google-bucket:edge output
```

## Introdução

**_Terraform Packager_** é uma coleção de _scripts_ e **templates** para **empacotar** código **Terrraform**.

O objetivo é criar um artefato que seja autosuficiente e personalizável.

Uma imagem criada usa o conceito de Stacks e contém essencialmente:

- **Terraform**: binário em uma versão específica do Terraform
- **HCL Code**: Código Terraform usado para criar recursos
- **Providers**: Os Terraform Providers serão baixados somente durante o build da imagem.

Esse conceito procura seguir a fisolofia de **"build once"**, ou seja, o build do artefato ocorre apenas uma vez e o mesmo artefato pode ser usado para criar várias instâncias da Stack usando diferentes credenciais.

## Dependências

1. Você precisará [instalar](https://github.com/smsilva/linux/blob/master/scripts/utilities/yq/install.sh) o `yq` utilitário para leitura de arquivos yaml.
2. Docker
3. Estes comandos foram testados no `Ubuntu 20.04`.

## Como usar

Se preferir ver um vídeo curto: [Terraform Packager: empacotando código Terraform](https://youtu.be/DDpqmtHY0Aw)

Para empacotar um código Terraform com o `terraform-packager` você precisa garantir que o diretório root do seu Módulo Terraform possua um arquivo `stack.yaml` com as seguintes variáveis:

```yaml
name: azure-nome-do-seu-modulo
version: 0.1.0
terraform:
  version: 1.0.9
  backend: azurerm
```

### Executando

O exemplo usado considera que você possua variáveis de ambiente do **Azure Resource Manager** configuradas:

```bash
ARM_SUBSCRIPTION_ID................: ID_DE_UMA_SUBSCRIPTION_NA_AZURE
ARM_TENANT_ID......................: ID_DO_TENANT_DA_SUBSCRIPTION
ARM_CLIENT_ID......................: ID_DE_UMA_SERVICE_PRINCIPAL_CRIADA_PARA_USO_COM_TERRAFORM
ARM_CLIENT_SECRET..................: SECRET_DA_SERVICE_PRINCIPAL_ACIMA
ARM_STORAGE_ACCOUNT_NAME...........: NOME_DO_STORAGE_ACCOUNT_QUE_SERA_USADO_PARA_ARMAZENAR_O_TFSTATE
ARM_STORAGE_ACCOUNT_CONTAINER_NAME.: NOME_DO_STORAGE_ACCOUNT_CONTAINER
ARM_SAS_TOKEN......................: UM_TOKEN_TEMPORARIO_USADO_PARA_ACESSAR_A_STORAGE_ACCOUNTS
```

### 1. Empacotando o Projeto de Exemplo

```bash
scripts/stackbuild "examples/azure-null-resource"
```

### 2. Executando o Container usando os valores padrão

```bash
scripts/stackrun azure-null-resource:latest plan
```

```bash
scripts/stackrun azure-null-resource:latest apply
```

### 3. Executando o Container usando arquivos de variáveis personalizadas

Embora não recomendável por ferir o princípio de que um artefato deveria sempre produzir o mesmo resultado, é possível passar um arquivo tfvars através de um volume para o container e usá-lo nos comandos Terraform.

```bash
export LOCAL_TERRAFORM_VARIABLES_DIRECTORY="${PWD}/examples/docker/custom-image"

scripts/stackrun azure-null-resource:latest plan -var-file=/opt/variables/terraform.tfvars
```

```bash
scripts/stackrun azure-null-resource:latest apply -var-file=/opt/variables/terraform.tfvars -auto-approve
```

### 4. Criando Imagens Personalizadas

```bash
scripts/stackbuild examples/azure-null-resource

docker build \
  --rm \
  --tag mystack:latest "examples/docker/custom-image"
```

```bash
scripts/stackrun mystack:latest plan
```

```bash
scripts/stackrun mystack:latest apply
```

### 5. Externalizando o Terraform State com backend `local`

#### 5.1. Informe o backend no arquivo `stack.yaml`:

```yaml
name: azure-null-resource
terraform:
  version: 1.8.5
  backend: local
```

#### 5.2. Por padrão o state será gerado no diretório configurado na variável de ambiente `LOCAL_TERRAFORM_OUTPUT_DIRECTORY`:

```bash
export LOCAL_TERRAFORM_OUTPUT_DIRECTORY="$(mktemp -d -t terraform-XXXXXXXXXX)"
echo "Terraform output directory: ${LOCAL_TERRAFORM_OUTPUT_DIRECTORY}"
```

#### 5.3. Execute o build

```bash
env DEBUG=2 scripts/stackbuild examples/azure-null-resource
```

#### 5.4. Configure o nome do arquivo de state

```bash
export TERRAFORM_STATE_FILE="azure-null-resource/terraform.state.json"
```

#### 5.5. Execute o plan e o apply

```bash
env DEBUG=2 scripts/stackrun azure-null-resource plan
env DEBUG=2 scripts/stackrun azure-null-resource apply
```

#### 5.6. Verifique os arquivos gerados

```bash
find "${LOCAL_TERRAFORM_OUTPUT_DIRECTORY?}" -type f
```

Exemplo de saída:

```bash
/tmp/terraform-Q72cCQBbWz/terraform.state
/tmp/terraform-Q72cCQBbWz/azure-null-resource/terraform.state.json
/tmp/terraform-Q72cCQBbWz/terraform.plan.json
/tmp/terraform-Q72cCQBbWz/terraform.plan
/tmp/terraform-Q72cCQBbWz/plan_detailed_exitcode
/tmp/terraform-Q72cCQBbWz/terraform.plan.txt
```

#### 5.7. Verificando o state

```bash
cat /tmp/terraform-Q72cCQBbWz/azure-null-resource/terraform.state.json
```

## Scripts para executar durante a fase de build

Se você precisar executar scripts durante a fase de build, você pode criar um diretório `.tfp/scripts/build` na raiz do seu repositório.

```bash
.
├── .tfp
│   └── scripts
│       └── build
│           └── install-az-cli
├── README.md
├── cz.yaml -> ../../cz.yaml
├── src
│   ├── main.tf
│   └── provider.tf
└── stack.yaml
```

Exemplo para o script `install-az-cli`:

```bash
#!/bin/bash
apk add py3-pip
apk add gcc musl-dev python3-dev libffi-dev openssl-dev cargo make
pip install --upgrade pip
pip install azure-cli
az version
```

## Scripts para executar durante runtime

Se você precisar executar scripts durante runtime, você pode criar um diretório `.tfp/scripts/runtime` na raiz do seu repositório.

```bash
.
├── .tfp
│   └── scripts
│       └── runtime
│           ├── after-apply
│           ├── after-destroy
│           ├── after-init
│           ├── after-plan
│           ├── before-apply
│           ├── before-destroy
│           ├── before-init
│           └── before-plan
├── README.md
├── cz.yaml -> ../../cz.yaml
├── src
│   ├── main.tf
│   └── provider.tf
└── stack.yaml
```

## Azure Credentials

O script `stackrun' vai montar os arquivos de credenciais do Azure CLI no container caso os arquivos existam e a variável de ambiente `ARM_CLIENT_ID` esteja vazia.

Caso necessite, você pode alterar as variáveis que identificam os arquivos de credenciais do Azure CLI:

```bash
# Abaixo as variáveis usadas pelo terraform-packager para identificar os arquivos de credenciais do Azure CLI com seus respectivos valores padrão
export TF_PACKAGER_AZURE_ACCESS_TOKEN_FILE="${HOME}/.azure/access_token.json"
export TF_PACKAGER_AZURE_PROFILE_FILE="${HOME}/.azure/azureProfile.json"
export TF_PACKAGER_AZURE_MSAL_TOKEN_CACHE_FILE="${HOME}/.azure/msal_token_cache.json"
```

> **ATENÇÃO**: Antes de executar `stackbuild` ou `stackrun`, certifique-se de ter obtido um token de acesso usando o comando:

```bash
export TF_PACKAGER_AZURE_ACCESS_TOKEN_FILE="${HOME}/.azure/access_token.json"
export TF_PACKAGER_AZURE_PROFILE_FILE="${HOME}/.azure/azureProfile.json"
export TF_PACKAGER_AZURE_MSAL_TOKEN_CACHE_FILE="${HOME}/.azure/msal_token_cache.json"

az account get-access-token > "${TF_PACKAGER_AZURE_ACCESS_TOKEN_FILE?}"

stackrun azure-cli-auth-example:latest plan
```

## Configurações SSH

Se você precisar configurar chaves SSH para acessar repositórios privados, você pode criar um arquivo `${HOME}./ssh/config` seguindo exemplo abaixo:

```bash
# GitHub
Host github.com
    HostName github.com
    IdentityFile ~/.ssh/id_ed25519

# Azure DevOps
Host ssh.dev.azure.com
    HostName ssh.dev.azure.com
    IdentityFile ~/.ssh/id_rsa

# Global
Host *
    User git
    PubkeyAcceptedAlgorithms +ssh-rsa
    HostkeyAlgorithms +ssh-rsa
    StrictHostKeyChecking no
```

## Variáveis de Ambiente

| Variável de Ambiente                            | Descrição                                                         | Exemplo                                                                                |
|-------------------------------------------------|-------------------------------------------------------------------|----------------------------------------------------------------------------------------|
| `DEBUG`                                         | Nível de depuração                                                | `DEBUG=2`                                                                              |
| `LOCAL_TERRAFORM_OUTPUT_DIRECTORY`              | Diretório onde o Terraform irá armazenar os arquivos de saída     | `LOCAL_TERRAFORM_OUTPUT_DIRECTORY="$(mktemp -d -t terraform-XXXXXXXXXX)"`              |
| `LOCAL_TERRAFORM_VARIABLES_DIRECTORY_EXTRA`     | Todos os arquivos do diretórios serão volumados em `/opt/src`     | `LOCAL_TERRAFORM_VARIABLES_DIRECTORY_EXTRA="${PWD}/examples/custom-image"`           |
| `LOCAL_TERRAFORM_VARIABLES_DIRECTORY`           | Diretório local que será volumado em `/opt/variables`             | `LOCAL_TERRAFORM_VARIABLES_DIRECTORY="${PWD}/examples/custom-image/tfvars-files"`      |
| `TERRAFORM_STATE_FILE`                          | Nome do arquivo de state                                          | `TERRAFORM_STATE_FILE="azure-null-resource/terraform.state.json"`                      |
| `TF_PACKAGER_AZURE_ACCESS_TOKEN_FILE`           | Arquivo de token de acesso do Azure CLI                           | `TF_PACKAGER_AZURE_ACCESS_TOKEN_FILE="${HOME}/.azure/access_token.json"`               |
| `TF_PACKAGER_AZURE_MSAL_TOKEN_CACHE_FILE`       | Arquivo de cache de token MSAL do Azure CLI                       | `TF_PACKAGER_AZURE_MSAL_TOKEN_CACHE_FILE="${HOME}/.azure/msal_token_cache.json"`       |
| `TF_PACKAGER_AZURE_PROFILE_FILE`                | Arquivo de perfil do Azure CLI                                    | `TF_PACKAGER_AZURE_PROFILE_FILE="${HOME}/.azure/azureProfile.json"`                    |
| `TF_PACKAGER_DOCKER_PROGRESS`                   | Definie como exibir p progresso do build do container Docker      | `TF_PACKAGER_DOCKER_PROGRESS=plain` (`auto`, `plain`, `tty`, `rawjson`)                |
| `TF_PACKAGER_TEMPORARY_BUILD_CONTEXT_DIRECTORY` | Diretório temporário para o build do container Docker             | `TF_PACKAGER_TEMPORARY_BUILD_CONTEXT_DIRECTORY="$(mktemp -d -t terraform-XXXXXXXXXX)"` |
