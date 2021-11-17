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
scripts/stackbuild "examples/azure-fake-module"
```

### 2. Executando o Container usando os valores padrão

```bash
scripts/stackrun azure-fake-module:latest plan
```

```bash
scripts/stackrun azure-fake-module:latest apply
```

### 3. Executando o Container usando arquivos de variáveis personalizadas

Embora não recomendável por ferir o princípio de que um artefato deveria sempre produzir o mesmo resultado, é possível passar um arquivo tfvars através de um volume para o container e usá-lo nos comandos Terraform.

```bash
export LOCAL_TERRAFORM_VARIABLES_DIRECTORY="${PWD}/example/azure-fake-module/environments/sandbox"

scripts/stackrun azure-fake-module:latest plan -var-file=/opt/variables/terraform.tfvars
```

```bash
scripts/stackrun azure-fake-module:latest apply -var-file=/opt/variables/terraform.tfvars -auto-approve
```

### 4. Criando Imagens Personalizadas

```bash
docker build --rm \
  --tag azure-fake-module/sandbox:latest "examples/azure-fake-module/environments/sandbox"
```

```bash
scripts/stackrun azure-fake-module/sandbox:latest plan
```

```bash
scripts/stackrun azure-fake-module/sandbox:latest apply
```
