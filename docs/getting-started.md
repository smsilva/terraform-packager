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
