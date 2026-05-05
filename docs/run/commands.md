# Comandos disponíveis

## Sintaxe

```bash
stackrun <image:tag> <comando> [argumentos...]
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
stackrun local-null-resource:latest plan
stackrun local-null-resource:latest apply
stackrun local-null-resource:latest destroy
stackrun local-null-resource:latest output
stackrun local-null-resource:latest info
stackrun local-null-resource:latest help
```

## Passando argumentos extras

Argumentos adicionais são repassados diretamente ao Terraform:

```bash
# Usar arquivo de variáveis
stackrun azure-storage-account:latest plan \
  -var-file=/opt/variables/producao.tfvars

# Apply sem confirmação interativa
stackrun azure-storage-account:latest apply \
  -var-file=/opt/variables/producao.tfvars \
  -auto-approve

# Destroy sem confirmação interativa
stackrun azure-storage-account:latest destroy \
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
DEBUG=3 stackrun local-null-resource:latest plan
```
