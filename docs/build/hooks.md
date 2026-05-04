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
