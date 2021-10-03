FROM hashicorp/terraform:${TERRAFORM_VERSION} AS terraform_base_image
ENV LOCK_TIMEOUT_SECONDS=300
ENV STACK_INSTANCE_NAME="${STACK_INSTANCE_NAME}"
ENV DEBUG="${TF_PACKAGER_DEBUG_LEVEL}"
RUN mkdir -p /opt/output/

FROM terraform_base_image AS package
ADD  src/             /opt/src
ADD  scripts/         /opt/scripts
ADD  credentials.conf /opt/credentials/credentials.conf
ADD  .ssh/            /root/.ssh/
WORKDIR /opt/src
RUN chmod 600 /root/.ssh/config && \
    /opt/scripts/terraform_init

FROM terraform_base_image AS final
COPY --from=package /opt/src /opt/src
COPY --from=package /opt/scripts/ /opt/scripts/
WORKDIR /opt/src
ENTRYPOINT ["/opt/scripts/entrypoint"]
