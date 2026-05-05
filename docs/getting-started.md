# Instalação e primeiro uso

## Pré-requisitos

1. **yq** — instalar via [script oficial](https://github.com/smsilva/linux/blob/master/scripts/utilities/yq/install.sh) ou `snap install yq`
2. **Docker** — versão 20.10 ou superior
3. Clonar o repositório:

```bash
git clone https://github.com/smsilva/terraform-packager.git
cd terraform-packager
```

Os scripts `stackbuild` e `stackrun` estão na pasta `scripts/` do repositório. Adicione-a ao `PATH` para chamá-los diretamente:

```bash
export PATH="/caminho/para/terraform-packager/scripts:${PATH}"
```

Ou chame com o caminho completo ou relativo: `./scripts/stackbuild`, `/opt/terraform-packager/scripts/stackrun`, etc.

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

O arquivo deve conter um bloco `terraform {}` com `backend "local" {}` como placeholder obrigatório. Esse valor é substituído em runtime pelo backend real configurado no `stack.yaml`.

```hcl
terraform {
  required_version = ">= 0.15.1, < 2.0.0"

  backend "local" {}

  required_providers {
    null = {
      source  = "hashicorp/null"
      version = ">=3.0.0"
    }
  }
}

provider "null" {}
```

## Primeiro build

```bash
stackbuild examples/local-null-resource
```

Saída esperada: imagem Docker `local-null-resource:latest` criada localmente.

## Primeiro run

```bash
stackrun local-null-resource:latest plan
stackrun local-null-resource:latest apply
```

## Próximos passos

- [Visão geral do build](build/overview.md) — entender as fases de build
- [Variáveis de ambiente](run/variables.md) — customizar o comportamento
- [Exemplos](examples.md) — ver projetos prontos para outros providers
