## 1.0.0 (2024-09-20)

### Refactor

- **scripts/stackrun**: only show stacrun script when debug level is greater than 2

## 0.34.1 (2024-09-19)

### Refactor

- scripts output

## 0.34.0 (2024-08-26)

### Feat

- **.github/workflows/pull-request.yaml**: create

### Fix

- **.github/workflows/pull-request.yaml**: template
- setup build

## 0.33.2 (2024-08-26)

### Refactor

- ssh configuration

## 0.33.1 (2024-08-14)

### Fix

- before-all scripts

## 0.33.0 (2024-08-14)

### Feat

- add before-all execution

## 0.32.0 (2024-08-12)

### Feat

- scripts for outputs retrieval
- save terraform outputs as json and install jq

## 0.31.2 (2024-07-04)

### Fix

- **templates/provider/github**: default owner environment variable

## 0.31.1 (2024-07-04)

### Fix

- **templates/provider/github**: add environment variable

## 0.31.0 (2024-07-04)

### Feat

- add github provider

## 0.30.0 (2024-06-26)

### Feat

- discovering terraform command name
- adding runtime scripts

## 0.29.0 (2024-06-24)

### Feat

- add azure-cli credentials during the build time

## 0.28.1 (2024-06-14)

### Fix

- **templates/scripts/terraform_init**: Show state-file info based on the backend

## 0.28.0 (2024-06-14)

### Feat

- Customize the local backend file name for terraform state

## 0.27.1 (2023-08-24)

### Fix

- **scripts/stackrun**: Check the directories and extra files

## 0.27.0 (2023-05-10)

### Feat

- Using .tfp/scripts/build/*

## 0.26.0 (2023-05-04)

### Feat

- **scripts/stackrun**: Use LOCAL_EXTRA_VOLUMES variable

### Refactor

- Remove unused files

## 0.25.0 (2023-03-22)

### Feat

- Improvements, -refreh-only/-refresh=true based on terraform version and help command

## 0.24.0 (2023-03-21)

### Feat

- Adding confluentcustom Provider

## 0.23.0 (2023-03-02)

### Feat

- Update examples

## 0.22.1 (2022-09-25)

### Fix

- **scripts/stackrun**: Remove not needed xargs parameter
- **examples/fastly-demo/src/provider.tf**: Update version restriction and provider block

## 0.22.0 (2022-09-14)

### Feat

- Add a fastly Provider support

## 0.21.0 (2022-08-13)

### Feat

- **destroy-twice-command**: create an alias command to deal with situations when a double attempt is demanded to destroy de resources

## 0.20.1 (2022-07-12)

### Fix

- **terraform_plan_no_color**: generate json file even if detailed-exit-code execution returns 2

## 0.20.0 (2022-06-19)

### Feat

- **templates/**: Add azuread provider and update azurerm backend to not use deprecated Microsoft Graph API
- **examples/**: Update example's terraform version to 1.2.2
- **examples/azure-null-resource/cz.yaml**: Create a symbolic link to the repository cz.yaml file

## 0.19.0 (2022-05-23)

### Feat

- **stackbuild**: Incorporate a manifest.yaml during the build process with image build timestamp and other relevant metadata

## 0.18.0 (2022-05-04)

### Feat

- Add New Relic Provider Template and azure-null-resource example

## 0.17.0 (2022-05-04)

### Feat

- New provider template for confluent

## 0.16.2 (2022-05-02)

### Fix

- Add ARM variables as TF_VAR

## 0.16.1 (2022-04-26)

### Fix

- **templates/provider/firewalldbs/**: Remove extra empty line

## 0.16.0 (2022-04-26)

### Feat

- **firewalldbs**: Create template folder for firewalldbs provider

## 0.15.1 (2022-04-26)

### Feat

- **firewalldbs**: Create template folder for firewalldbs provider

### Fix

- **terraform_plan_no_color**: preserve exit code of the plan command but still piping the output to a logfile

## 0.15.0 (2022-04-24)

### Feat

- **stackrun**: externalize LOCAL_TERRAFORM_OUTPUT_DIRECTORY, allowing reconfiguration
- **examples/azure-multi-provider/src/provider.tf**: Enable most recent provider version

## 0.14.0 (2022-04-09)

### Feat

- **input-variables**: transmit all TF_VAR_ files of the environment to the stackrun command
- **local-backend**: create a local backend option on templates

## 0.13.0 (2022-03-31)

### Feat

- **hcvault**: a provider to a custom hcvault

## 0.12.0 (2022-03-27)

### Feat

- **templates/provider/azurerm/credentials_run.conf**: Add new ARM runtime variables

## 0.11.0 (2022-03-26)

### Feat

- **templates/provider/helm/**: Add helm provider files

## 0.10.1 (2022-03-26)

### Fix

- **entrypoint**: declare TF_CLI_ARGS_init='-no-color' to fix format output on plan-no-color command

## 0.10.0 (2022-03-22)

### Feat

- **templates/provider/rabbitmq/**: Add an empty provider folder
- **scripts/stackrun**: Loop through templates/provider/*/credentials_run.conf files
- **scripts/create_build_context**: Generate a new file with Provider Credentials into the Build Context Directory
- **scripts/show_build_parameters**: Add debug information for Provider List
- **templates/provider/null/**: Create new null Terraform Provider folder
- **examples/azure-multi-provider/src/**: Create new azure-multi-provider example

### Fix

- **templates/provider/null/**: Use USER Environment Variable

### Refactor

- Removing unecessary last line spaces
- **scripts/**: Change the name of credentials provider file and remove unused references

## 0.9.0 (2022-03-16)

### Feat

- **scripts/stackrun**: Add the capacity to volume Multiple varfiles
- **stack.yaml**: Update Terraform version to 1.1.7

## 0.8.0 (2022-03-26)

### Feat

- **azdevops**: declare azuredevops as a new available provider

## 0.7.1 (2022-02-21)

### Fix

- **confluent-cloud**: make provider/confluent-cloud/debug executable

## 0.7.0 (2022-02-21)

### Feat

- **confluentcloud**: add confluentcloud (kafka) as a provider option

## 0.6.5 (2022-02-15)

### Fix

- **build_setup_variables**: use only the first provider of provider.tf file to choose the provider credentials

## 0.6.4 (2022-02-09)

## 0.6.3 (2022-02-08)

### Fix

- **scripts**: update terraform_apply_with_auto_approve script
- **templates**: Make apply command compatible to older TF versions

## 0.6.2 (2022-02-01)

### Fix

- **templates**: change provider from atlas to mongodbatlas

## 0.6.1 (2022-01-27)

### Fix

- **mongodb-provider**: remove organization-id from mongodb provider template

## 0.6.0 (2022-01-21)

### Feat

- **providers**: create cloudamqp provider templates
- **providers**: create cloudamqp provider templates
- **providers**: create imperva provider templates
- **providers**: create atlas mongodb provider templates

### Fix

- fix a bug where you can't pass variable with plan file
- **ssh_config**: update ssh_config template file

## 0.4.4 (2022-01-18)

### Feat

- **templates/entrypoint**: Add terraform command options for the pre-defined scripts

### Refactor

- fix issue with $@
- use correct var
- change the args parser
- add optional arguments to commands

## 0.4.3 (2021-12-22)

## 0.4.2 (2021-12-14)

### Fix

- **debug**: hide arm accees key when debug is 2

## 0.4.1 (2021-12-14)

### Fix

- **stackrun**: adding arm access key variable

## 0.4.0 (2021-12-13)

### Feat

- **backend**: add access key to backend template

## 0.3.0 (2022-09-14)

### Feat

- Add a fastly Provider support

## 0.21.0 (2022-08-13)

### Feat

- **destroy-twice-command**: create an alias command to deal with situations when a double attempt is demanded to destroy de resources

## 0.20.1 (2022-07-12)

### Fix

- **terraform_plan_no_color**: generate json file even if detailed-exit-code execution returns 2

## 0.20.0 (2022-06-19)

### Feat

- **templates/**: Add azuread provider and update azurerm backend to not use deprecated Microsoft Graph API
- **examples/**: Update example's terraform version to 1.2.2
- **examples/azure-null-resource/cz.yaml**: Create a symbolic link to the repository cz.yaml file

## 0.19.0 (2022-05-23)

### Feat

- **stackbuild**: Incorporate a manifest.yaml during the build process with image build timestamp and other relevant metadata

## 0.18.0 (2022-05-04)

### Feat

- Add New Relic Provider Template and azure-null-resource example

## 0.17.0 (2022-05-04)

### Feat

- New provider template for confluent

## 0.16.2 (2022-05-02)

### Fix

- Add ARM variables as TF_VAR

## 0.16.1 (2022-04-26)

### Fix

- **templates/provider/firewalldbs/**: Remove extra empty line

## 0.16.0 (2022-04-26)

### Feat

- **firewalldbs**: Create template folder for firewalldbs provider

## 0.15.1 (2022-04-26)

### Feat

- **firewalldbs**: Create template folder for firewalldbs provider

### Fix

- **terraform_plan_no_color**: preserve exit code of the plan command but still piping the output to a logfile

## 0.15.0 (2022-04-24)

### Feat

- **stackrun**: externalize LOCAL_TERRAFORM_OUTPUT_DIRECTORY, allowing reconfiguration
- **examples/azure-multi-provider/src/provider.tf**: Enable most recent provider version

## 0.14.0 (2022-04-09)

### Feat

- **input-variables**: transmit all TF_VAR_ files of the environment to the stackrun command
- **local-backend**: create a local backend option on templates

## 0.13.0 (2022-03-31)

### Feat

- **hcvault**: a provider to a custom hcvault

## 0.12.0 (2022-03-27)

### Feat

- **templates/provider/azurerm/credentials_run.conf**: Add new ARM runtime variables

## 0.11.0 (2022-03-26)

### Feat

- **templates/provider/helm/**: Add helm provider files

## 0.10.1 (2022-03-26)

### Fix

- **entrypoint**: declare TF_CLI_ARGS_init='-no-color' to fix format output on plan-no-color command

## 0.10.0 (2022-03-22)

### Feat

- **templates/provider/rabbitmq/**: Add an empty provider folder
- **scripts/stackrun**: Loop through templates/provider/*/credentials_run.conf files
- **scripts/create_build_context**: Generate a new file with Provider Credentials into the Build Context Directory
- **scripts/show_build_parameters**: Add debug information for Provider List
- **templates/provider/null/**: Create new null Terraform Provider folder
- **examples/azure-multi-provider/src/**: Create new azure-multi-provider example

### Fix

- **templates/provider/null/**: Use USER Environment Variable

### Refactor

- Removing unecessary last line spaces
- **scripts/**: Change the name of credentials provider file and remove unused references

## 0.9.0 (2022-03-16)

### Feat

- **scripts/stackrun**: Add the capacity to volume Multiple varfiles
- **stack.yaml**: Update Terraform version to 1.1.7

## 0.8.0 (2022-03-26)

### Feat

- **azdevops**: declare azuredevops as a new available provider

## 0.7.1 (2022-02-21)

### Fix

- **confluent-cloud**: make provider/confluent-cloud/debug executable

## 0.7.0 (2022-02-21)

### Feat

- **confluentcloud**: add confluentcloud (kafka) as a provider option

## 0.6.5 (2022-02-15)

### Fix

- **build_setup_variables**: use only the first provider of provider.tf file to choose the provider credentials

## 0.6.4 (2022-02-09)

## 0.6.3 (2022-02-08)

### Fix

- **scripts**: update terraform_apply_with_auto_approve script
- **templates**: Make apply command compatible to older TF versions

## 0.6.2 (2022-02-01)

### Fix

- **templates**: change provider from atlas to mongodbatlas

## 0.6.1 (2022-01-27)

### Fix

- **mongodb-provider**: remove organization-id from mongodb provider template

## 0.6.0 (2022-01-21)

### Feat

- **providers**: create cloudamqp provider templates
- **providers**: create cloudamqp provider templates
- **providers**: create imperva provider templates
- **providers**: create atlas mongodb provider templates

### Fix

- fix a bug where you can't pass variable with plan file
- **ssh_config**: update ssh_config template file

## 0.4.4 (2022-01-18)

### Feat

- **templates/entrypoint**: Add terraform command options for the pre-defined scripts

### Refactor

- fix issue with $@
- use correct var
- change the args parser
- add optional arguments to commands

## 0.4.3 (2021-12-22)

## 0.4.2 (2021-12-14)

### Fix

- **debug**: hide arm accees key when debug is 2

## 0.4.1 (2021-12-14)

### Fix

- **stackrun**: adding arm access key variable

## 0.4.0 (2021-12-13)

### Feat

- **backend**: add access key to backend template

## 0.3.0 (2021-12-10)

### Feat

- **resource-group**: resource-group creation instead of data
- **state**: stack instance name for state
- **examples**: azure-bucket terraform version

## 0.2.14 (2021-12-08)

### Refactor

- **debug**: change debug azure provider

## 0.2.13 (2021-12-01)

### Fix

- **backend**: add google bucket name for gcs backend config

## 0.2.12 (2021-11-28)

### Fix

- **validate**: check if stack.yaml file exists

## 0.2.11 (2021-11-22)

### Fix

- **google-credentials**: google credentials now gets from base64 environment variables

## 0.2.10 (2021-11-22)

### Fix

- **scripts**: code exit into scripts

## 0.2.9 (2021-11-22)

### Refactor

- **terraform-hcl-code**: Remove unused reference

## 0.2.8 (2021-11-22)

### Refactor

- **remove-yq-use**: Remove yq use from scripts

## 0.2.7 (2021-11-17)

### Refactor

- **example**: google-bucket inputs and outputs

## 0.2.6 (2021-11-14)

### Fix

- **version**: commitizen version using when no version were provided

## 0.2.5 (2021-11-13)

### Fix

- **stackrun**: fix run when use container registry with image name

## 0.2.4 (2021-11-13)

### Fix

- **stackrun**: enable the script to be executed from anywhere since the scripts folder is in the PATH variable

## 0.2.3 (2021-10-30)

### Fix

- **plugin_cache_dir**: Fix plugin_cache_dir usage

## 0.2.2 (2021-10-29)

### Fix

- **aws-provider**: AWS Provider support using Azure Storage Account as Terraform Backend
- **stackrun**: Create a templating engine to generate execution script

## 0.2.0 (2022-09-14)

### Feat

- Add a fastly Provider support

## 0.21.0 (2022-08-13)

### Feat

- **destroy-twice-command**: create an alias command to deal with situations when a double attempt is demanded to destroy de resources

## 0.20.1 (2022-07-12)

### Fix

- **terraform_plan_no_color**: generate json file even if detailed-exit-code execution returns 2

## 0.20.0 (2022-06-19)

### Feat

- **templates/**: Add azuread provider and update azurerm backend to not use deprecated Microsoft Graph API
- **examples/**: Update example's terraform version to 1.2.2
- **examples/azure-null-resource/cz.yaml**: Create a symbolic link to the repository cz.yaml file

## 0.19.0 (2022-05-23)

### Feat

- **stackbuild**: Incorporate a manifest.yaml during the build process with image build timestamp and other relevant metadata

## 0.18.0 (2022-05-04)

### Feat

- Add New Relic Provider Template and azure-null-resource example

## 0.17.0 (2022-05-04)

### Feat

- New provider template for confluent

## 0.16.2 (2022-05-02)

### Fix

- Add ARM variables as TF_VAR

## 0.16.1 (2022-04-26)

### Fix

- **templates/provider/firewalldbs/**: Remove extra empty line

## 0.16.0 (2022-04-26)

### Feat

- **firewalldbs**: Create template folder for firewalldbs provider

## 0.15.1 (2022-04-26)

### Fix

- **terraform_plan_no_color**: preserve exit code of the plan command but still piping the output to a logfile

### Feat

- **firewalldbs**: Create template folder for firewalldbs provider

## 0.15.0 (2022-04-24)

### Feat

- **stackrun**: externalize LOCAL_TERRAFORM_OUTPUT_DIRECTORY, allowing reconfiguration
- **examples/azure-multi-provider/src/provider.tf**: Enable most recent provider version

## 0.14.0 (2022-04-09)

### Feat

- **input-variables**: transmit all TF_VAR_ files of the environment to the stackrun command
- **local-backend**: create a local backend option on templates

## 0.13.0 (2022-03-31)

### Feat

- **hcvault**: a provider to a custom hcvault

## 0.12.0 (2022-03-27)

### Feat

- **templates/provider/azurerm/credentials_run.conf**: Add new ARM runtime variables

## 0.11.0 (2022-03-26)

### Feat

- **templates/provider/helm/**: Add helm provider files

## 0.10.1 (2022-03-26)

### Fix

- **entrypoint**: declare TF_CLI_ARGS_init='-no-color' to fix format output on plan-no-color command

## 0.10.0 (2022-03-22)

### Feat

- **templates/provider/rabbitmq/**: Add an empty provider folder
- **scripts/stackrun**: Loop through templates/provider/*/credentials_run.conf files
- **scripts/create_build_context**: Generate a new file with Provider Credentials into the Build Context Directory
- **scripts/show_build_parameters**: Add debug information for Provider List
- **templates/provider/null/**: Create new null Terraform Provider folder
- **examples/azure-multi-provider/src/**: Create new azure-multi-provider example

### Refactor

- Removing unecessary last line spaces
- **scripts/**: Change the name of credentials provider file and remove unused references

### Fix

- **templates/provider/null/**: Use USER Environment Variable

## 0.9.0 (2022-03-16)

### Feat

- **scripts/stackrun**: Add the capacity to volume Multiple varfiles
- **stack.yaml**: Update Terraform version to 1.1.7

## 0.8.0 (2022-03-26)

### Feat

- **azdevops**: declare azuredevops as a new available provider

## 0.7.1 (2022-02-21)

### Fix

- **confluent-cloud**: make provider/confluent-cloud/debug executable

## 0.7.0 (2022-02-21)

### Feat

- **confluentcloud**: add confluentcloud (kafka) as a provider option
- **confluentcloud**: add confluentcloud (kafka) as a provider option

## 0.6.5 (2022-02-15)

### Fix

- **build_setup_variables**: choose provider credentials based on the first ocurrence
- **build_setup_variables**: use only the first provider of provider.tf file to choose the provider credentials

## 0.6.4 (2022-02-09)

### Fix

- **templates**: Make apply command compatible to older TF versions

## 0.6.3 (2022-02-08)

### Fix

- **scripts**: update terraform_apply_with_auto_approve script
- **templates**: Make apply command compatible to older TF versions

## 0.6.2 (2022-02-01)

### Fix

- **templates**: change provider from atlas to mongodbatlas

## 0.6.1 (2022-01-27)

### Fix

- **mongodb-provider**: remove organization-id from mongodb provider template

## 0.6.0 (2022-01-21)

### Fix

- fix a bug where you can't pass variable with plan file
- **ssh_config**: update ssh_config template file

### Feat

- **providers**: create cloudamqp provider templates
- **providers**: create cloudamqp provider templates
- **providers**: create imperva provider templates
- **providers**: create atlas mongodb provider templates

## 0.4.4 (2022-01-18)

### Feat

- **templates/entrypoint**: Add terraform command options for the pre…
- **templates/entrypoint**: Add terraform command options for the pre-defined scripts

### Refactor

- fix issue with $@
- use correct var
- change the args parser
- add optional arguments to commands

## 0.4.3 (2021-12-22)

## 0.4.2 (2021-12-14)

### Fix

- **debug**: hide arm accees key when debug is 2

## 0.4.1 (2021-12-14)

### Fix

- **stackrun**: adding arm access key variable

## 0.4.0 (2021-12-13)

### Feat

- **backend**: add access key to backend template

## 0.3.0 (2021-12-10)

### Feat

- **resource-group**: resource-group creation instead of data
- **state**: stack instance name for state
- **examples**: azure-bucket terraform version

## 0.2.14 (2021-12-08)

### Refactor

- **debug**: change debug azure provider

## 0.2.13 (2021-12-01)

### Fix

- **backend**: add google bucket name for gcs backend config

## 0.2.12 (2021-11-28)

### Fix

- **validate**: check if stack.yaml file exists

## 0.2.11 (2021-11-22)

### Fix

- **google-credentials**: google credentials now gets from base64 environment variables

## 0.2.10 (2021-11-22)

### Fix

- **scripts**: code exit into scripts

## 0.2.9 (2021-11-22)

### Refactor

- **terraform-hcl-code**: Remove unused reference

## 0.2.8 (2021-11-22)

### Refactor

- **remove-yq-use**: Remove yq use from scripts

## 0.2.7 (2021-11-17)

### Refactor

- **example**: google-bucket inputs and outputs

## 0.2.6 (2021-11-14)

### Fix

- **version**: commitizen version using when no version were provided

## 0.2.5 (2021-11-13)

### Fix

- **stackrun**: fix run when use container registry with image name

## 0.2.4 (2021-11-13)

### Fix

- **stackrun**: enable the script to be executed from anywhere since the scripts folder is in the PATH variable

## 0.2.3 (2021-10-30)

### Fix

- **plugin_cache_dir**: Fix plugin_cache_dir usage

## 0.2.2 (2021-10-29)

### Fix

- **aws-provider**: AWS Provider support using Azure Storage Account as Terraform Backend
- **stackrun**: Create a templating engine to generate execution script

## 0.2.0 (2021-10-03)

### Feat

- **build**: Adding dynamic support for docker, buildah and kaniko

## 0.1.3 (2021-10-03)

### Refactor

- **test**: A helper script was created to help with tests
- **Dockerfiles-dev-and-sandbox**: Customize the instance name for Terraform Sate

## 0.1.1 (2021-10-03)

### Refactor

- **templates/build/Dockerfile**: Removing some blank spaces

## 0.1.0 (2021-10-03)

### Feat

- **build**: Building a Custom Image to Package Terraform Code

## 0.0.1 (2021-10-03)
