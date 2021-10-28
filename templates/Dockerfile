FROM hashicorp/terraform:${TERRAFORM_VERSION} AS terraform_base_image
ENV LOCK_TIMEOUT_SECONDS=300
ENV STACK_INSTANCE_NAME="${STACK_INSTANCE_NAME}"
ENV DEBUG="${TF_PACKAGER_DEBUG_LEVEL}"
RUN mkdir -p /opt/output/

FROM terraform_base_image AS package
ENV  TF_PLUGIN_CACHE_DIR="/opt/terraform/plugin_cache_dir"
VOLUME ${TF_PLUGIN_CACHE_DIR}              /opt/terraform/plugin_cache_dir
ADD  .ssh/                                 /root/.ssh/
ADD  backend_fragment.hcl                  /opt/backend/fragment.hcl
ADD  backend.conf                          /opt/backend/template.conf
ADD  credentials.json                      /opt/terraform/credentials.json
ADD  credentials.conf                      /opt/terraform/credentials.conf
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
