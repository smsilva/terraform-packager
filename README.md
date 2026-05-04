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
