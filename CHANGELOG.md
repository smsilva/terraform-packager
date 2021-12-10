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
