FROM hashicorp/terraform:${TERRAFORM_VERSION} AS terraform_base_image
ENV LOCK_TIMEOUT_SECONDS=300
ENV STACK_INSTANCE_NAME="${STACK_INSTANCE_NAME}"
ENV TERRAFORM_PROVIDER="${TERRAFORM_PROVIDER}"
ENV TERRAFORM_BACKEND="${TERRAFORM_BACKEND}"
ENV DEBUG="${TF_PACKAGER_DEBUG_LEVEL}"
RUN mkdir -p /opt/output/

FROM terraform_base_image AS package
ADD  .ssh/                                 /root/.ssh/
ADD  credentials_provider.conf             /opt/terraform/credentials_provider.conf
ADD  credentials_backend.conf              /opt/terraform/credentials_backend.conf
ADD  environment_variables.conf            /opt/environment_variables.conf
ADD  templates/                            /opt/templates
ADD  scripts/                              /opt/scripts
ADD  src/                                  /opt/src
WORKDIR /opt/src
RUN chmod 600 /root/.ssh/config && \
    /opt/scripts/terraform_init

FROM terraform_base_image AS final
COPY --from=package /opt/environment_variables.conf /opt/environment_variables.conf
COPY --from=package /opt/templates/                 /opt/templates/
COPY --from=package /opt/scripts/                   /opt/scripts/
COPY --from=package /opt/src                        /opt/src
WORKDIR /opt/src
ENTRYPOINT ["/opt/scripts/entrypoint"]
