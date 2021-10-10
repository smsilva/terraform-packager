#!/bin/bash
BASE64ENCODED_ARM_SUBSCRIPTION_ID=$(               echo -n "${ARM_SUBSCRIPTION_ID?}"                | base64 | tr -d "\n") && \
BASE64ENCODED_ARM_TENANT_ID=$(                     echo -n "${ARM_TENANT_ID?}"                      | base64 | tr -d "\n") && \
BASE64ENCODED_ARM_CLIENT_ID=$(                     echo -n "${ARM_CLIENT_ID?}"                      | base64 | tr -d "\n") && \
BASE64ENCODED_ARM_CLIENT_SECRET=$(                 echo -n "${ARM_CLIENT_SECRET?}"                  | base64 | tr -d "\n") && \
BASE64ENCODED_ARM_STORAGE_ACCOUNT_NAME=$(          echo -n "${ARM_STORAGE_ACCOUNT_NAME?}"           | base64 | tr -d "\n") && \
BASE64ENCODED_ARM_STORAGE_ACCOUNT_CONTAINER_NAME=$(echo -n "${ARM_STORAGE_ACCOUNT_CONTAINER_NAME?}" | base64 | tr -d "\n") && \
BASE64ENCODED_ARM_SAS_TOKEN=$(                     echo -n "${ARM_SAS_TOKEN?}"                      | base64 | tr -d "\n") && \
kubectl apply -f - <<EOF
---
apiVersion: v1
kind: Secret
metadata:
  name: arm-credentials
  namespace: default
type: Opaque
data:
  ARM_SUBSCRIPTION_ID:                ${BASE64ENCODED_ARM_SUBSCRIPTION_ID}
  ARM_TENANT_ID:                      ${BASE64ENCODED_ARM_TENANT_ID}
  ARM_CLIENT_ID:                      ${BASE64ENCODED_ARM_CLIENT_ID}
  ARM_CLIENT_SECRET:                  ${BASE64ENCODED_ARM_CLIENT_SECRET}
  ARM_STORAGE_ACCOUNT_NAME:           ${BASE64ENCODED_ARM_STORAGE_ACCOUNT_NAME}
  ARM_STORAGE_ACCOUNT_CONTAINER_NAME: ${BASE64ENCODED_ARM_STORAGE_ACCOUNT_CONTAINER_NAME}
  ARM_SAS_TOKEN:                      ${BASE64ENCODED_ARM_SAS_TOKEN}
EOF
