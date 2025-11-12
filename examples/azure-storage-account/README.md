# azure-storage-account

## Como usar

```bash
export LOCAL_TERRAFORM_VARIABLES_DIRECTORY="${PWD}/examples/azure-storage-account/variables-extra"

./scripts/stackbuild examples/azure-storage-account

./scripts/stackrun azure-storage-account:latest help

export STACK_INSTANCE_NAME="one"
./scripts/stackrun azure-storage-account:latest plan -var-file=/opt/variables/one.auto.tfvars
./scripts/stackrun azure-storage-account:latest apply -var-file=/opt/variables/one.auto.tfvars -auto-approve
./scripts/stackrun azure-storage-account:latest destroy -var-file=/opt/variables/one.auto.tfvars -auto-approve

export STACK_INSTANCE_NAME="two"
./scripts/stackrun azure-storage-account:latest plan -var-file=/opt/variables/two.auto.tfvars
./scripts/stackrun azure-storage-account:latest apply -var-file=/opt/variables/two.auto.tfvars -auto-approve
./scripts/stackrun azure-storage-account:latest destroy -var-file=/opt/variables/two.auto.tfvars -auto-approve
```
