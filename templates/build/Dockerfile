FROM hashicorp/terraform:${TERRAFORM_VERSION} AS terraform_base_image
ENV LOCK_TIMEOUT_SECONDS=300
ENV STACK_INSTANCE_NAME="${STACK_INSTANCE_NAME}"
ENV DEBUG="${TF_PACKAGER_DEBUG_LEVEL}"
RUN mkdir -p /opt/output/

FROM terraform_base_image AS package
ADD  .ssh/                                 /root/.ssh/
ADD  backend_fragment.hcl                  /opt/backend/fragment.hcl
ADD  backend.conf                          /opt/backend/template.conf
ADD  service-account.json                  /opt/credentials/service-account.json
ADD  credentials.conf                      /opt/credentials/credentials.conf
ADD  environment_variables.conf            /opt/environment_variables.conf
ADD  scripts/                              /opt/scripts
ADD  src/                                  /opt/src
WORKDIR /opt/src
RUN chmod 600 /root/.ssh/config && \
    /opt/scripts/terraform_init

FROM terraform_base_image AS final
COPY --from=package /opt/environment_variables.conf /opt/environment_variables.conf
COPY --from=package /opt/backend/template.conf      /opt/backend/template.conf
COPY --from=package /opt/scripts/                   /opt/scripts/
COPY --from=package /opt/src                        /opt/src
WORKDIR /opt/src
ENTRYPOINT ["/opt/scripts/entrypoint"]
