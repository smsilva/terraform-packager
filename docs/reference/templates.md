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
