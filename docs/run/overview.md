# Visão geral do runtime

## Comando

```bash
stackrun <image:tag> <comando> [argumentos...]
```

## Fluxo de execução

```
stackrun
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
