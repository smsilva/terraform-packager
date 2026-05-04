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
