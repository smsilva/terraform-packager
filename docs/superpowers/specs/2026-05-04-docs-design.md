# Design: Documentação do Terraform Packager

**Data:** 2026-05-04
**Público-alvo:** Desenvolvedores que querem usar o terraform-packager em seus projetos
**Idioma:** Português
**Escopo:** Refatoração do README.md + criação da pasta `docs/`

---

## Contexto

O `README.md` atual cobre quase todos os temas relevantes, mas numa única página longa e sem hierarquia clara. O objetivo é reescrever o README como introdução + quick start e mover o conteúdo detalhado para `docs/`, organizado por tema.

Os READMEs individuais dos exemplos (`examples/*/README.md`) permanecem onde estão.

---

## Estrutura de Arquivos

```
README.md                    ← reescrito: intro + quick start + link para docs/
docs/
  README.md                  ← índice navegável
  getting-started.md
  build/
    overview.md
    stack-yaml.md
    hooks.md
  run/
    overview.md
    commands.md
    variables.md
    credentials.md
    ssh.md
    hooks.md
  reference/
    providers.md
    backends.md
    templates.md
  examples.md
```

---

## Descrição de Cada Arquivo

### `README.md` (raiz — reescrito)

- Parágrafo curto explicando o conceito: build once, imagem autossuficiente com binário Terraform + código HCL + providers
- Dependências: `yq`, Docker
- Quick start em ~10 linhas: clone → build → run usando `local-null-resource`
- Link para `docs/` para conteúdo completo

Tudo além do quick start (variáveis, hooks, SSH, backends, exemplos avançados) sai do README e vai para `docs/`.

---

### `docs/README.md` (índice)

Sumário navegável sem conteúdo próprio. Links agrupados:

- **Começando**: getting-started.md
- **Build**: build/overview.md, build/stack-yaml.md, build/hooks.md
- **Run**: run/overview.md, run/commands.md, run/variables.md, run/credentials.md, run/ssh.md, run/hooks.md
- **Referência**: reference/providers.md, reference/backends.md, reference/templates.md
- **Exemplos**: examples.md

---

### `docs/getting-started.md`

- Pré-requisitos: instalar `yq`, Docker, clonar o repo
- Estrutura mínima de um projeto: `stack.yaml` obrigatório + `src/provider.tf`, com exemplo comentado
- Primeiro build: `scripts/stackbuild examples/local-null-resource`
- Primeiro run: `scripts/stackrun local-null-resource:latest plan`
- Próximos passos: links para build/, run/ e examples.md

Usa `local-null-resource` como exemplo por não exigir credenciais de cloud.

---

### `docs/build/overview.md`

- Fases do build: leitura do `stack.yaml`, detecção do provider, montagem do contexto em `~/.terraform-packager/`, execução do builder
- Resolução do `STACK_VERSION`: stack.yaml → cz.yaml → git hash → "latest"
- Seleção do builder via `TF_PACKAGER_CONTAINER_BUILDER`: docker (padrão), buildah, kaniko
- Níveis de DEBUG: 0 (silencioso), 1 (parâmetros), 2 (parâmetros + output do builder)

### `docs/build/stack-yaml.md`

- Referência completa do `stack.yaml`: todos os campos, tipos, valores padrão
- Como `name` vira nome da imagem Docker
- Como `terraform.version` é usado para selecionar o binário
- Como `terraform.backend` determina qual template de backend é usado
- Exemplos para cada backend suportado

### `docs/build/hooks.md`

- O que são hooks de build: scripts em `.tfp/scripts/build/`
- Quando são executados: stage `terraform_base_image` do Dockerfile, antes do `terraform init`
- Caso de uso principal: instalar ferramentas extras na imagem (ex: Azure CLI)
- Exemplo real baseado no `azure-null-resource`
- Boas práticas: usar `apk add`, scripts pequenos e focados, testar localmente antes

---

### `docs/run/overview.md`

- O que acontece no runtime: geração do script `docker run` em `~/.stackrun_generated.sh`, montagem de volumes, execução de `terraform_init` → `terraform <command>`
- Fluxo: `stackrun` → script gerado → container → entrypoint → terraform

### `docs/run/commands.md`

- Referência de todos os comandos: `plan`, `apply`, `destroy`, `output`, `info`, `help`
- Sintaxe: `scripts/stackrun <image:tag> <command> [args...]`
- Como passar argumentos extras: `-var-file`, `-auto-approve`, etc.
- Níveis de DEBUG: 1 (parâmetros), 3 (parâmetros + script gerado)

### `docs/run/variables.md`

Tabela completa de variáveis de ambiente de **runtime** agrupadas por categoria:

| Categoria | Variáveis |
|-----------|-----------|
| Saída | `LOCAL_TERRAFORM_OUTPUT_DIRECTORY`, `TERRAFORM_STATE_FILE` |
| Volumes | `LOCAL_TERRAFORM_VARIABLES_DIRECTORY`, `LOCAL_TERRAFORM_VARIABLES_DIRECTORY_EXTRA`, `LOCAL_EXTRA_VOLUMES` |
| Instância | `STACK_INSTANCE_NAME` |
| Debug | `DEBUG` |

Como `TF_VAR_*` é passado automaticamente para dentro do container.

> Variáveis de build (`TF_PACKAGER_CONTAINER_BUILDER`, `TF_PACKAGER_DOCKER_PROGRESS`, `TF_PACKAGER_TEMPORARY_BUILD_CONTEXT_DIRECTORY`) são documentadas em `build/overview.md`.

### `docs/run/credentials.md`

- Montagem automática de credenciais Azure CLI quando `ARM_CLIENT_ID` está vazio e os arquivos existem
- Variáveis para customizar caminhos: `TF_PACKAGER_AZURE_ACCESS_TOKEN_FILE`, `TF_PACKAGER_AZURE_PROFILE_FILE`, `TF_PACKAGER_AZURE_MSAL_TOKEN_CACHE_FILE`
- Credenciais via variáveis de ambiente para outros providers (AWS, GCP, etc.)

### `docs/run/ssh.md`

- Como configurar `~/.ssh/config` para repositórios privados durante o run
- Exemplo completo com GitHub e Azure DevOps
- Algoritmos de chave suportados

### `docs/run/hooks.md`

- Hooks de runtime: scripts em `.tfp/scripts/runtime/`
- Todos os pontos de extensão disponíveis:
  - `before-all` — antes de qualquer comando
  - `before-init` / `after-init`
  - `before-plan` / `after-plan`
  - `before-apply` / `after-apply`
  - `before-destroy` / `after-destroy`
- Exemplos de uso: exportar outputs, notificar sistemas externos, validações pré-deploy
- Quando cada hook é chamado na sequência de execução

---

### `docs/reference/providers.md`

- Lista de todos os providers suportados: aws, azurerm, azuread, azuredevops, azure, google, github, fastly, helm, cloudamqp, confluent, confluentcloud, hcvault, imperva, mongodbatlas, newrelic, rabbitmq, external, local, null
- Para cada provider: variáveis de ambiente necessárias em build e em run
- Como o provider é detectado automaticamente a partir de `src/provider.tf`
- Como adicionar suporte a um provider não listado: estrutura esperada em `templates/provider/<name>/`

### `docs/reference/backends.md`

- Backends suportados: `azurerm`, `gcs`, `s3`, `local`
- Para cada backend: variáveis de ambiente necessárias e exemplo de `stack.yaml`
- Onde ficam os arquivos de configuração: `templates/backend/<name>/`

### `docs/reference/templates.md`

- `Dockerfile`: estágios `terraform_base_image`, `package`, `final` e o que cada um faz
- `environment_variables.conf`: variáveis embutidas na imagem final
- `stackrun.conf`: configuração padrão do runtime
- `manifest.yaml`: metadados da imagem
- `templates/scripts/`: scripts embarcados no container (entrypoint, terraform_init, etc.)

---

### `docs/examples.md`

Tabela dos exemplos disponíveis com colunas: nome, provider, backend, link para README local.

Guia de quando usar cada exemplo:

| Cenário | Exemplo recomendado |
|---------|---------------------|
| Sem credenciais de cloud | `local-null-resource` |
| Azure (simples) | `azure-null-resource` |
| Azure (múltiplas instâncias) | `azure-storage-account` |
| Múltiplos providers Azure | `azure-multi-provider` |
| Módulos Terraform | `azure-network-using-module` |
| AWS | `aws-bucket` |
| GCP | `google-bucket` |
| Fastly | `fastly-demo` |
| Imagem Docker customizada | `docker/custom-image` |

---

## O que não muda

- `examples/*/README.md` — permanecem nos diretórios de exemplo
- `CLAUDE.md` — não é afetado
- `CHANGELOG.md` — não é afetado
- Código em `scripts/`, `templates/` — sem alterações

## Decisões

- Idioma: português
- Estrutura: subpastas por tema (build/, run/, reference/)
- README raiz: reescrito como intro + quick start
- Exemplos: índice em `docs/examples.md`, READMEs locais preservados
