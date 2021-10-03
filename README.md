# Terraform Packager

Terraform Packager é uma coleção de scripts para empacotar código Terrraform.

O objetivo é criar um artefato que seja autosuficiente e personalizável.

Uma imagem criada usa o conceito de Stacks e contém essencialmente:

- **Terraform**: binário em uma versão específica do Terraform
- **HCL Code**: Código Terraform usado para criar recursos
- **Providers**: Os Terraform Providers serão baixados somente durante o build da imagem.

Esse conceito procura seguir a fisolofia de "build once", ou seja, o build do artefato ocorre apenas uma vez e o mesmo artefato pode ser usado para criar várias instâncias da Stack usando diferentes credenciais.

## Como usar

Para empacotar um código Terraform, você precisa garantir que o seu código possua um arquivo stack.conf com as seguintes variáveis:

- `STACK_NAME`: o nome da Stack que será usado para nomear a imagem do container.
- `TERRAFORM_VERSION`: a versão do Terraform que será usada como imagem base.

### Executando

O exemplo usado considera que você possua variáveis de ambiente do Azure Resource Manager configuradas:

```bash
ARM_SUBSCRIPTION_ID................: ID_DE_UMA_SUBSCRIPTION_NA_AZURE
ARM_TENANT_ID......................: ID_DO_TENANT_DA_SUBSCRIPTION
ARM_CLIENT_ID......................: ID_DE_UMA_SERVICE_PRINCIPAL_CRIADA_PARA_USO_COM_TERRAFORM
ARM_CLIENT_SECRET..................: SECRET_DA_SERVICE_PRINCIPAL_ACIMA
ARM_STORAGE_ACCOUNT_NAME...........: NOME_DO_STORAGE_ACCOUNT_QUE_SERA_USADO_PARA_ARMAZENAR_O_TFSTATE
ARM_STORAGE_ACCOUNT_CONTAINER_NAME.: NOME_DO_STORAGE_ACCOUNT_CONTAINER
ARM_SAS_TOKEN......................: UM_TOKEN_TEMPORARIO_USADO_PARA_ACESSAR_A_STORAGE_ACCOUNTS
```

### 1. Azure CLI e Variáveis de Ambiente do Azure Resource Manager (ARM)

Confira se as variáveis de ambiente estão configuradas antes de prosseguir:

```bash
scripts/show_arm_variables
```

```bash
ARM_SUBSCRIPTION_ID................: 7f65403e-eec5-45c4-a4ac-1eafc74192ca
ARM_TENANT_ID......................: 16aaff56-7bcd-474f-a975-fe20562ee656
ARM_CLIENT_ID......................: 7dcc3fa0-2794-4ed7-b84f-cd31e244d34d
ARM_CLIENT_SECRET..................: 36
ARM_STORAGE_ACCOUNT_NAME...........: acmestorage
ARM_STORAGE_ACCOUNT_CONTAINER_NAME.: terraform
ARM_SAS_TOKEN......................: 116
```

### 2. Obtendo um SAS Token

O script `scripts/security/arm_sas_token_set_env_variable` obtém um SAS Token usando o Azure CLI.

O SAS Token expira em 1 hora e será usado para acessar o Storage Account que armazenará o State File do Terraform.

```bash
`scripts/security/arm_sas_token_set_env_variable`
```

Confira se as variáveis de ambiente estão configuradas antes de prosseguir:

```bash
scripts/show_arm_variables
```

```bash
ARM_SUBSCRIPTION_ID................: 7f65403e-eec5-45c4-a4ac-1eafc74192ca
ARM_TENANT_ID......................: 16aaff56-7bcd-474f-a975-fe20562ee656
ARM_CLIENT_ID......................: 7dcc3fa0-2794-4ed7-b84f-cd31e244d34d
ARM_CLIENT_SECRET..................: 36
ARM_STORAGE_ACCOUNT_NAME...........: acmestorage
ARM_STORAGE_ACCOUNT_CONTAINER_NAME.: terraform
ARM_SAS_TOKEN......................: 116
```

### 3. Empacotando o Projeto de Exemplo

```bash
./run "${PWD}/example/azure-dummy-stack/src"
```

### 4. Executando o Container usando os valores padrão

```bash
scripts/azrun azure-dummy-stack:latest plan
```

```bash
scripts/azrun azure-dummy-stack:latest apply
```

### 5. Executando o Container usando arquivos de variáveis personalizadas

Embora não recomendável por ferir o princípio de que um artefato deveria sempre produzir o mesmo resultado, é possível passar um arquivo tfvars através de um volume para o container e usá-lo nos comandos Terraform.

```bash
export LOCAL_TERRAFORM_VARIABLES_DIRECTORY="${PWD}/example/azure-dummy-stack/environments/sandbox"

scripts/azrun azure-dummy-stack:latest plan -var-file=/opt/vars/terraform.tfvars
```

```bash
scripts/azrun azure-dummy-stack:latest apply -var-file=/opt/vars/terraform.tfvars -auto-approve
```

### 6. Criando Imagens Personalizadas

#### Sandbox

```bash
docker build --rm \
  --tag azure-dummy-stack/sandbox:latest "example/azure-dummy-stack/environments/sandbox"
```

```bash
scripts/azrun azure-dummy-stack/sandbox:latest plan
```

```bash
scripts/azrun azure-dummy-stack/sandbox:latest apply
```

#### Dev

```bash
docker build --rm \
  --tag azure-dummy-stack/dev:latest "example/azure-dummy-stack/environments/dev"
```

```bash
scripts/azrun azure-dummy-stack/dev:latest plan
```

```bash
scripts/azrun azure-dummy-stack/dev:latest apply
```
