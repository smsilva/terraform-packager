# Configuração SSH

Para acessar repositórios privados (módulos Terraform em repositórios privados), configure o arquivo `~/.ssh/config` no host. O `stackrun` monta automaticamente as chaves SSH no container.

## Exemplo de ~/.ssh/config

```
# GitHub
Host github.com
    HostName github.com
    IdentityFile ~/.ssh/id_ed25519

# Azure DevOps
Host ssh.dev.azure.com
    HostName ssh.dev.azure.com
    IdentityFile ~/.ssh/id_rsa

# Global
Host *
    User git
    PubkeyAcceptedAlgorithms +ssh-rsa
    HostkeyAlgorithms +ssh-rsa
    StrictHostKeyChecking no
```

A opção `StrictHostKeyChecking no` evita falhas na primeira conexão com hosts desconhecidos dentro do container.
