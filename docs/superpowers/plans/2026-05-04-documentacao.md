# Documentação do Terraform Packager — Plano de Implementação

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Criar estrutura completa de documentação em `docs/` e reescrever `README.md` como introdução + quick start.

**Architecture:** 15 arquivos Markdown organizados em subpastas temáticas (build/, run/, reference/). O README.md raiz é reescrito como introdução + quick start. Cada arquivo é independente e linkado pelo índice em `docs/README.md`. Não há testes automatizados — validação é feita por revisão visual do conteúdo e verificação de links.

**Tech Stack:** Markdown (GitHub-flavored)

---

### Task 1: Reescrever README.md

**Files:**
- Modify: `README.md`

- [ ] **Step 1: Substituir o conteúdo do README.md pelo seguinte:**

```markdown
# Terraform Packager

**Terraform Packager** empacota código Terraform em imagens Docker autossuficientes chamadas _Stacks_. Cada imagem contém um binário Terraform, o código HCL e os providers pré-baixados — pronta para rodar com diferentes credenciais sem rebuild.

## Dependências

- [`yq`](https://github.com/mikefarah/yq) — leitura de arquivos YAML
- Docker

## Quick start

```bash
git clone https://github.com/smsilva/terraform-packager.git
cd terraform-packager

# Build
scripts/stackbuild examples/local-null-resource

# Run
scripts/stackrun local-null-resource:latest plan
scripts/stackrun local-null-resource:latest apply
```

## Documentação completa

→ [`docs/`](docs/README.md)
```

- [ ] **Step 2: Verificar que os links e blocos de código estão corretos**

Abrir `README.md` no editor e confirmar que não há conteúdo antigo remanescente.

- [ ] **Step 3: Commit**

```bash
git add README.md
git commit -m "docs(README): rewrite as intro and quick start"
```

---

### Task 2: Criar docs/README.md (índice)

**Files:**
- Create: `docs/README.md`

- [ ] **Step 1: Criar o arquivo com o seguinte conteúdo:**

```markdown
# Documentação — Terraform Packager

## Começando

- [Instalação e primeiro uso](getting-started.md)

## Build

- [Visão geral do build](build/overview.md)
- [Referência do stack.yaml](build/stack-yaml.md)
- [Hooks de build](build/hooks.md)

## Run

- [Visão geral do runtime](run/overview.md)
- [Comandos disponíveis](run/commands.md)
- [Variáveis de ambiente](run/variables.md)
- [Credenciais](run/credentials.md)
- [Configuração SSH](run/ssh.md)
- [Hooks de runtime](run/hooks.md)

## Referência

- [Providers suportados](reference/providers.md)
- [Backends suportados](reference/backends.md)
- [Templates](reference/templates.md)

## Exemplos

- [Exemplos disponíveis](examples.md)
```

- [ ] **Step 2: Commit**

```bash
git add docs/README.md
git commit -m "docs: add documentation index"
```

---

### Task 3: Criar docs/getting-started.md

**Files:**
- Create: `docs/getting-started.md`

- [ ] **Step 1: Criar o arquivo com o seguinte conteúdo:**

```markdown
# Instalação e primeiro uso

## Pré-requisitos

1. **yq** — instalar via [script oficial](https://github.com/smsilva/linux/blob/master/scripts/utilities/yq/install.sh) ou `snap install yq`
2. **Docker** — versão 20.10 ou superior
3. Clonar o repositório:

```bash
git clone https://github.com/smsilva/terraform-packager.git
cd terraform-packager
```

## Estrutura mínima de um projeto

Qualquer projeto Terraform empacotável precisa de dois arquivos obrigatórios:

```
meu-projeto/
├── stack.yaml       # configuração da Stack
└── src/
    └── provider.tf  # declaração do provider Terraform
```

### stack.yaml

```yaml
name: meu-projeto        # nome da imagem Docker gerada
terraform:
  version: 1.8.5         # versão do binário Terraform
  backend: local         # backend para armazenar o state
```

### src/provider.tf

```hcl
provider "null" {}
```

## Primeiro build

```bash
scripts/stackbuild examples/local-null-resource
```

Saída esperada: imagem Docker `local-null-resource:latest` criada localmente.

## Primeiro run

```bash
scripts/stackrun local-null-resource:latest plan
scripts/stackrun local-null-resource:latest apply
```

## Próximos passos

- [Visão geral do build](build/overview.md) — entender as fases de build
- [Variáveis de ambiente](run/variables.md) — customizar o comportamento
- [Exemplos](examples.md) — ver projetos prontos para outros providers
```

- [ ] **Step 2: Commit**

```bash
git add docs/getting-started.md
git commit -m "docs: add getting-started guide"
```

---

### Task 4: Criar docs/build/overview.md

**Files:**
- Create: `docs/build/overview.md`

- [ ] **Step 1: Criar o diretório**

```bash
mkdir -p docs/build
```

- [ ] **Step 2: Criar o arquivo com o seguinte conteúdo:**

```markdown
# Visão geral do build

## Comando

```bash
scripts/stackbuild <diretório-do-projeto>
```

Exemplo:

```bash
scripts/stackbuild examples/azure-storage-account
```

## Fases do build

| Fase | O que acontece |
|------|----------------|
| 1. Leitura | `stack.yaml` é lido para extrair `name`, `terraform.version`, `terraform.backend` |
| 2. Detecção | Provider detectado automaticamente a partir de `src/provider.tf` |
| 3. Contexto | Diretório temporário montado em `~/.terraform-packager/` com Dockerfile, scripts, credenciais e código fonte |
| 4. Build | Builder selecionado executa o build e gera a imagem `{name}:{version}` |

## Resolução de STACK_VERSION

A versão da imagem é resolvida na seguinte ordem de prioridade:

1. Campo `version:` no `stack.yaml`
2. Campo `version:` no `cz.yaml` do projeto
3. Hash do último commit git (`git log -1 --pretty=%h`)
4. `"latest"` (fallback)

## Seleção do builder

| Variável | Valor padrão | Opções |
|----------|-------------|--------|
| `TF_PACKAGER_CONTAINER_BUILDER` | `docker` | `docker`, `buildah`, `kaniko` |

```bash
TF_PACKAGER_CONTAINER_BUILDER=buildah scripts/stackbuild examples/local-null-resource
```

## Variáveis de ambiente do build

| Variável | Padrão | Descrição |
|----------|--------|-----------|
| `TF_PACKAGER_CONTAINER_BUILDER` | `docker` | Builder a ser usado |
| `TF_PACKAGER_DOCKER_PROGRESS` | `auto` | Formato do progresso: `auto`, `plain`, `tty`, `rawjson` |
| `TF_PACKAGER_TEMPORARY_BUILD_CONTEXT_DIRECTORY` | `~/.terraform-packager/` | Diretório temporário do build context |
| `DEBUG` | `2` | Nível de verbosidade (veja abaixo) |

## Níveis de DEBUG

| Valor | Comportamento |
|-------|--------------|
| `0` | Sem mensagens |
| `1` | Exibe parâmetros de build |
| `2` | Exibe parâmetros + output do builder (padrão) |

```bash
DEBUG=0 scripts/stackbuild examples/local-null-resource  # silencioso
DEBUG=1 scripts/stackbuild examples/local-null-resource  # só parâmetros
```
```

- [ ] **Step 3: Commit**

```bash
git add docs/build/overview.md
git commit -m "docs(build): add build overview"
```

---

### Task 5: Criar docs/build/stack-yaml.md

**Files:**
- Create: `docs/build/stack-yaml.md`

- [ ] **Step 1: Criar o arquivo com o seguinte conteúdo:**

```markdown
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
```

- [ ] **Step 2: Commit**

```bash
git add docs/build/stack-yaml.md
git commit -m "docs(build): add stack-yaml reference"
```

---

### Task 6: Criar docs/build/hooks.md

**Files:**
- Create: `docs/build/hooks.md`

- [ ] **Step 1: Criar o arquivo com o seguinte conteúdo:**

```markdown
# Hooks de build

Hooks de build são scripts executados durante a construção da imagem Docker, no stage `terraform_base_image`, antes do `terraform init`.

## Localização

```
meu-projeto/
└── .tfp/
    └── scripts/
        └── build/
            └── meu-script   ← executado durante o build
```

Todos os scripts encontrados em `.tfp/scripts/build/` são executados em ordem alfabética.

## Caso de uso principal

Instalar ferramentas adicionais na imagem. A imagem base usa Alpine Linux — o gerenciador de pacotes é `apk`.

## Exemplo: instalar Azure CLI

Arquivo: `.tfp/scripts/build/install-az-cli`

```bash
#!/bin/bash
apk add py3-pip
apk add gcc musl-dev python3-dev libffi-dev openssl-dev cargo make
pip install --upgrade pip
pip install azure-cli
az version
```

Este exemplo está disponível em [`examples/azure-null-resource/.tfp/scripts/build/`](../../examples/azure-null-resource/.tfp/scripts/build/).

## Boas práticas

- Manter scripts com responsabilidade única
- Usar `apk add` para pacotes do sistema (Alpine Linux)
- Usar `pip install` para pacotes Python
- Testar o script isoladamente antes de incluir no build
- Usar prefixo numérico para controlar a ordem de execução (`01-instalar-ferramentas`, `02-configurar-ambiente`)
```

- [ ] **Step 2: Commit**

```bash
git add docs/build/hooks.md
git commit -m "docs(build): add build hooks guide"
```

---

### Task 7: Criar docs/run/overview.md

**Files:**
- Create: `docs/run/overview.md`

- [ ] **Step 1: Criar o diretório**

```bash
mkdir -p docs/run
```

- [ ] **Step 2: Criar o arquivo com o seguinte conteúdo:**

```markdown
# Visão geral do runtime

## Comando

```bash
scripts/stackrun <image:tag> <comando> [argumentos...]
```

## Fluxo de execução

```
scripts/stackrun
    │
    ├── Gera ~/.stackrun_generated.sh (script docker run)
    │       ├── Monta volumes (output, variáveis, credenciais)
    │       ├── Injeta variáveis de ambiente (TF_VAR_*, credenciais de provider/backend)
    │       └── Executa o comando informado
    │
    └── Executa ~/.stackrun_generated.sh
            │
            └── Container Docker
                    │
                    └── entrypoint
                            ├── terraform_init
                            └── terraform <comando>
```

## O que é montado automaticamente

| Volume | Origem (host) | Destino (container) |
|--------|---------------|---------------------|
| Saída | `LOCAL_TERRAFORM_OUTPUT_DIRECTORY` | `/opt/output/` |
| Variáveis | `LOCAL_TERRAFORM_VARIABLES_DIRECTORY` | `/opt/variables/` |
| Extra (arquivos) | `LOCAL_TERRAFORM_VARIABLES_DIRECTORY_EXTRA` | `/opt/src/<arquivo>` |
| State file | `LOCAL_TERRAFORM_OUTPUT_DIRECTORY/TERRAFORM_STATE_FILE` | `/opt/output/<TERRAFORM_STATE_FILE>` |

Variáveis de ambiente com prefixo `TF_VAR_` são automaticamente passadas para dentro do container.
```

- [ ] **Step 3: Commit**

```bash
git add docs/run/overview.md
git commit -m "docs(run): add runtime overview"
```

---

### Task 8: Criar docs/run/commands.md

**Files:**
- Create: `docs/run/commands.md`

- [ ] **Step 1: Criar o arquivo com o seguinte conteúdo:**

```markdown
# Comandos disponíveis

## Sintaxe

```bash
scripts/stackrun <image:tag> <comando> [argumentos...]
```

## Comandos

| Comando | Descrição |
|---------|-----------|
| `plan` | Gera o plano de execução do Terraform |
| `apply` | Aplica as mudanças |
| `destroy` | Destrói os recursos |
| `output` | Exibe os outputs do Terraform |
| `info` | Exibe informações da Stack (versão, provider, backend) |
| `help` | Exibe a ajuda |

## Exemplos

```bash
scripts/stackrun local-null-resource:latest plan
scripts/stackrun local-null-resource:latest apply
scripts/stackrun local-null-resource:latest destroy
scripts/stackrun local-null-resource:latest output
scripts/stackrun local-null-resource:latest info
scripts/stackrun local-null-resource:latest help
```

## Passando argumentos extras

Argumentos adicionais são repassados diretamente ao Terraform:

```bash
# Usar arquivo de variáveis
scripts/stackrun azure-storage-account:latest plan \
  -var-file=/opt/variables/producao.tfvars

# Apply sem confirmação interativa
scripts/stackrun azure-storage-account:latest apply \
  -var-file=/opt/variables/producao.tfvars \
  -auto-approve

# Destroy sem confirmação interativa
scripts/stackrun azure-storage-account:latest destroy \
  -var-file=/opt/variables/producao.tfvars \
  -auto-approve
```

O arquivo de variáveis deve estar no diretório configurado em `LOCAL_TERRAFORM_VARIABLES_DIRECTORY` (montado em `/opt/variables/` dentro do container).

## Níveis de DEBUG

| Valor | Comportamento |
|-------|--------------|
| `0` | Sem mensagens |
| `1` | Exibe parâmetros de execução (padrão) |
| `3` | Exibe parâmetros + script `docker run` gerado |

```bash
DEBUG=3 scripts/stackrun local-null-resource:latest plan
```
```

- [ ] **Step 2: Commit**

```bash
git add docs/run/commands.md
git commit -m "docs(run): add commands reference"
```

---

### Task 9: Criar docs/run/variables.md

**Files:**
- Create: `docs/run/variables.md`

- [ ] **Step 1: Criar o arquivo com o seguinte conteúdo:**

```markdown
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
scripts/stackrun azure-storage-account:latest apply

export STACK_INSTANCE_NAME="staging"
scripts/stackrun azure-storage-account:latest apply
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
scripts/stackrun azure-storage-account:latest plan
```

> Variáveis de build (`TF_PACKAGER_CONTAINER_BUILDER`, `TF_PACKAGER_DOCKER_PROGRESS`, `TF_PACKAGER_TEMPORARY_BUILD_CONTEXT_DIRECTORY`) estão documentadas em [build/overview.md](../build/overview.md).
```

- [ ] **Step 2: Commit**

```bash
git add docs/run/variables.md
git commit -m "docs(run): add environment variables reference"
```

---

### Task 10: Criar docs/run/credentials.md

**Files:**
- Create: `docs/run/credentials.md`

- [ ] **Step 1: Criar o arquivo com o seguinte conteúdo:**

```markdown
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

scripts/stackrun azure-storage-account:latest plan
```

### Usando Azure CLI (montagem automática)

Se `ARM_CLIENT_ID` estiver vazio e os arquivos de credenciais do Azure CLI existirem no host, o `stackrun` os monta automaticamente no container:

```bash
az login
az account get-access-token > "${HOME}/.azure/access_token.json"

scripts/stackrun azure-storage-account:latest plan
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

scripts/stackrun aws-bucket:latest plan
```

## Google Cloud

```bash
export GOOGLE_CREDENTIALS="$(cat credentials.json | tr -d '\n')"
export GOOGLE_PROJECT="meu-projeto"
export GOOGLE_BUCKET="meu-bucket-state"
export GOOGLE_PREFIX="terraform"

scripts/stackrun google-bucket:latest plan
```
```

- [ ] **Step 2: Commit**

```bash
git add docs/run/credentials.md
git commit -m "docs(run): add credentials guide"
```

---

### Task 11: Criar docs/run/ssh.md e docs/run/hooks.md

**Files:**
- Create: `docs/run/ssh.md`
- Create: `docs/run/hooks.md`

- [ ] **Step 1: Criar docs/run/ssh.md com o seguinte conteúdo:**

```markdown
# Configuração SSH

Para acessar repositórios privados (módulos Terraform em repositórios privados), configure o arquivo `~/.ssh/config` no host. O `stackrun` monta automaticamente as chaves SSH no container.

## Exemplo de ~/.ssh/config

```
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

A opção `StrictHostKeyChecking no` evita falhas na primeira conexão com hosts desconhecidos dentro do container.
```

- [ ] **Step 2: Criar docs/run/hooks.md com o seguinte conteúdo:**

```markdown
# Hooks de runtime

Hooks de runtime são scripts executados em momentos específicos da execução do Terraform dentro do container.

## Localização

```
meu-projeto/
└── .tfp/
    └── scripts/
        └── runtime/
            ├── before-all      ← antes de qualquer comando
            ├── before-init
            ├── after-init
            ├── before-plan
            ├── after-plan
            ├── before-apply
            ├── after-apply
            ├── before-destroy
            └── after-destroy
```

## Sequência de execução

Para o comando `apply`:

```
before-all → before-init → terraform init → after-init → before-apply → terraform apply → after-apply
```

Para o comando `plan`:

```
before-all → before-init → terraform init → after-init → before-plan → terraform plan → after-plan
```

## Casos de uso

| Hook | Uso típico |
|------|-----------|
| `before-all` | Validações globais, configurações de ambiente |
| `before-init` | Preparar credenciais dinâmicas |
| `after-init` | Verificar estado do backend |
| `before-plan` | Injetar variáveis dinâmicas |
| `after-plan` | Analisar o plano, notificar equipe |
| `before-apply` | Backups, gates de aprovação |
| `after-apply` | Notificações, exportar outputs para outros sistemas |
| `before-destroy` | Confirmações adicionais, backups |
| `after-destroy` | Limpeza de recursos dependentes |

## Exemplo: notificar após apply

Arquivo: `.tfp/scripts/runtime/after-apply`

```bash
#!/bin/bash
echo "Apply concluído em $(date)"
curl -s -X POST "${WEBHOOK_URL}" \
  -H "Content-Type: application/json" \
  -d "{\"text\": \"Stack ${STACK_NAME} aplicada com sucesso\"}"
```

Este exemplo está disponível em [`examples/azure-null-resource/.tfp/scripts/runtime/`](../../examples/azure-null-resource/.tfp/scripts/runtime/).
```

- [ ] **Step 3: Commit**

```bash
git add docs/run/ssh.md docs/run/hooks.md
git commit -m "docs(run): add SSH and runtime hooks guides"
```

---

### Task 12: Criar docs/reference/providers.md

**Files:**
- Create: `docs/reference/providers.md`

- [ ] **Step 1: Criar o diretório**

```bash
mkdir -p docs/reference
```

- [ ] **Step 2: Criar o arquivo com o seguinte conteúdo:**

```markdown
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
```

- [ ] **Step 3: Commit**

```bash
git add docs/reference/providers.md
git commit -m "docs(reference): add providers reference"
```

---

### Task 13: Criar docs/reference/backends.md

**Files:**
- Create: `docs/reference/backends.md`

- [ ] **Step 1: Criar o arquivo com o seguinte conteúdo:**

```markdown
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
```

- [ ] **Step 2: Commit**

```bash
git add docs/reference/backends.md
git commit -m "docs(reference): add backends reference"
```

---

### Task 14: Criar docs/reference/templates.md

**Files:**
- Create: `docs/reference/templates.md`

- [ ] **Step 1: Criar o arquivo com o seguinte conteúdo:**

```markdown
# Templates

O diretório `templates/` contém todos os arquivos usados internamente pelo terraform-packager para construir e executar Stacks.

## Dockerfile

`templates/Dockerfile` — gerado dinamicamente com substituição de variáveis de ambiente. Possui três stages:

| Stage | Base | O que faz |
|-------|------|-----------|
| `terraform_base_image` | `hashicorp/terraform:{versão}` | Instala bash e jq, copia scripts e templates, executa hooks de build (`.tfp/scripts/build/`) |
| `package` | `terraform_base_image` | Copia chaves SSH, credenciais Azure, executa `terraform init` (baixa providers) |
| `final` | `terraform_base_image` | Copia apenas `environment_variables.conf` e o `src/` inicializado. Remove segredos de build. |

O stage `final` é a imagem publicada — não contém credenciais usadas durante o build.

## environment_variables.conf

`templates/environment_variables.conf` — variáveis embutidas na imagem final. Contém configurações padrão do runtime disponíveis como variáveis de ambiente dentro do container.

## stackrun.conf

`templates/stackrun.conf` — configuração base do script `docker run` gerado pelo `stackrun`. Define flags padrão do container (mapeamentos de volumes e modo de execução).

## manifest.yaml

`templates/manifest.yaml` — metadados da imagem gerada (nome, versão, provider, backend, data de build).

## templates/scripts/

Scripts embarcados dentro da imagem Docker:

| Script | Propósito |
|--------|-----------|
| `entrypoint` | Ponto de entrada do container. Carrega `environment_variables.conf`, executa hooks `before-all` e despacha para o comando solicitado |
| `terraform_init` | Executa `terraform init` com a configuração de backend gerada |
| `build_extra` | Orquestra a execução dos hooks de build (`.tfp/scripts/build/`) |
| `runtime_extra` | Orquestra a execução dos hooks de runtime (`.tfp/scripts/runtime/`) |
| `generate_backend_configuration_file` | Gera o arquivo de configuração do backend a partir do template |
| `show_debug_information` | Exibe informações de debug sobre a Stack |
| `show_help` | Exibe a ajuda do container |
| `log` | Utilitário de log interno |

## templates/provider/ e templates/backend/

Subdiretórios por provider/backend com arquivos de credenciais e configuração. Ver [Providers](providers.md) e [Backends](backends.md).
```

- [ ] **Step 2: Commit**

```bash
git add docs/reference/templates.md
git commit -m "docs(reference): add templates reference"
```

---

### Task 15: Criar docs/examples.md

**Files:**
- Create: `docs/examples.md`

- [ ] **Step 1: Criar o arquivo com o seguinte conteúdo:**

```markdown
# Exemplos

Todos os exemplos ficam em `examples/`. Cada um tem seu próprio `README.md` com instruções detalhadas.

## Exemplos disponíveis

| Exemplo | Provider | Backend | README |
|---------|----------|---------|--------|
| `local-null-resource` | null | local | [README](../examples/local-null-resource/README.md) |
| `azure-null-resource` | azurerm | azurerm | [README](../examples/azure-null-resource/README.md) |
| `azure-storage-account` | azurerm | azurerm | [README](../examples/azure-storage-account/README.md) |
| `azure-multi-provider` | azurerm + azuread | azurerm | — |
| `azure-network-using-module` | azurerm | azurerm | — |
| `aws-bucket` | aws | s3 | — |
| `google-bucket` | google | gcs | — |
| `fastly-demo` | fastly | — | — |
| `docker/custom-image` | — | — | — |

## Por onde começar

| Cenário | Exemplo recomendado |
|---------|---------------------|
| Sem credenciais de cloud (teste local) | `local-null-resource` |
| Azure (caso mais simples) | `azure-null-resource` |
| Azure com múltiplas instâncias | `azure-storage-account` |
| Múltiplos providers Azure | `azure-multi-provider` |
| Módulos Terraform | `azure-network-using-module` |
| AWS | `aws-bucket` |
| Google Cloud | `google-bucket` |
| Fastly | `fastly-demo` |
| Imagem Docker customizada | `docker/custom-image` |
```

- [ ] **Step 2: Commit**

```bash
git add docs/examples.md
git commit -m "docs: add examples index"
```
