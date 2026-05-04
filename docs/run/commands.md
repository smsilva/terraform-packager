# Comandos disponíveis

## Sintaxe

```bash
scripts/stackrun <image:tag> <comando> [argumentos...]
```

## Comandos

| Comando | Descrição |
|---------|-----------|
| `plan` | Gera o plano de execução do Terraform |
| `apply` | Aplica as mudanças |
| `destroy` | Destrói os recursos |
| `output` | Exibe os outputs do Terraform |
| `info` | Exibe informações da Stack (versão, provider, backend) |
| `help` | Exibe a ajuda |

## Exemplos

```bash
scripts/stackrun local-null-resource:latest plan
scripts/stackrun local-null-resource:latest apply
scripts/stackrun local-null-resource:latest destroy
scripts/stackrun local-null-resource:latest output
scripts/stackrun local-null-resource:latest info
scripts/stackrun local-null-resource:latest help
```

## Passando argumentos extras

Argumentos adicionais são repassados diretamente ao Terraform:

```bash
# Usar arquivo de variáveis
scripts/stackrun azure-storage-account:latest plan \
  -var-file=/opt/variables/producao.tfvars

# Apply sem confirmação interativa
scripts/stackrun azure-storage-account:latest apply \
  -var-file=/opt/variables/producao.tfvars \
  -auto-approve

# Destroy sem confirmação interativa
scripts/stackrun azure-storage-account:latest destroy \
  -var-file=/opt/variables/producao.tfvars \
  -auto-approve
```

O arquivo de variáveis deve estar no diretório configurado em `LOCAL_TERRAFORM_VARIABLES_DIRECTORY` (montado em `/opt/variables/` dentro do container).

## Níveis de DEBUG

| Valor | Comportamento |
|-------|--------------|
| `0` | Sem mensagens |
| `1` | Exibe parâmetros de execução (padrão) |
| `3` | Exibe parâmetros + script `docker run` gerado |

```bash
DEBUG=3 scripts/stackrun local-null-resource:latest plan
```
