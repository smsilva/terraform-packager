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
