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
