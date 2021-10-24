#!/bin/bash
docker run \
  -v "${LOCAL_TERRAFORM_VARIABLES_DIRECTORY}:/opt/variables/" \
  -v "${LOCAL_TERRAFORM_OUTPUT_DIRECTORY}:/opt/output/" \
  -e DEBUG="${DEBUG}" \
  -e STACK_INSTANCE_NAME="${STACK_INSTANCE_NAME-default}" \
  -e GOOGLE_PROJECT="${GOOGLE_PROJECT?}" \
  -e GOOGLE_BUCKET="${GOOGLE_BUCKET?}" \
  -e GOOGLE_PREFIX="${GOOGLE_PREFIX?}" \
  -v "${GOOGLE_CREDENTIALS_FILE?}:/opt/credentials/service-account.json" \
gcp-fake-module:latest plan
