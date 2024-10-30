# Base image
FROM hashicorp/terraform:${TERRAFORM_VERSION} AS terraform_base_image
RUN apk add --no-cache bash jq
RUN addgroup -g 998 docker && \
    adduser -u 1001 -D -h /home/terraform terraform && \
    echo "terraform:terraform" | chpasswd && \
    addgroup terraform docker
ENV  LOCK_TIMEOUT_SECONDS=300
ENV  STACK_INSTANCE_NAME_FINAL=""
ENV  STACK_INSTANCE_NAME="${STACK_INSTANCE_NAME}"
ENV  TERRAFORM_PROVIDER="${TERRAFORM_PROVIDER}"
ENV  TERRAFORM_BACKEND="${TERRAFORM_BACKEND}"
ENV  DEBUG="${TF_PACKAGER_DEBUG_LEVEL}"
RUN  mkdir -p /opt/output/
ADD  scripts/   /opt/scripts
ADD  templates/ /opt/templates
RUN  /opt/scripts/build_extra

# Intermediate image to build using sensitive information
FROM terraform_base_image AS intermediate_image
ADD  .ssh/                      /root/.ssh/
ADD  .azure/                    /root/.azure/
ADD  credentials_provider.conf  /opt/terraform/credentials_provider.conf
ADD  credentials_backend.conf   /opt/terraform/credentials_backend.conf
ADD  environment_variables.conf /opt/environment_variables.conf
ADD  src/                       /opt/src
WORKDIR /opt/src
RUN chmod 600 /root/.ssh/config
RUN /opt/scripts/terraform_init

# Final image without sensitive information
FROM terraform_base_image AS final
COPY --from=intermediate_image /opt/environment_variables.conf /opt/environment_variables.conf
COPY --from=intermediate_image /opt/src                        /opt/src
RUN chown -R terraform:docker /opt /home/terraform && \
    chmod -R 775 /opt /home/terraform
USER terraform
WORKDIR /opt/src
ENTRYPOINT ["/opt/scripts/entrypoint"]
