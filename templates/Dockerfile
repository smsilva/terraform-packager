FROM hashicorp/terraform:1.8.5 AS terraform_base_image
RUN  apk add --no-cache sudo bash jq
RUN addgroup -g 1001 runner && \
    adduser -D -h /home/agent agent && \
    echo "agent:agent" | chpasswd && \
    addgroup agent runner
RUN echo "%runner ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
USER agent
ENV  LOCK_TIMEOUT_SECONDS=300
ENV  STACK_INSTANCE_NAME_FINAL=""
ENV  STACK_INSTANCE_NAME="default"
ENV  TERRAFORM_PROVIDER="local"
ENV  TERRAFORM_BACKEND="local"
ENV  DEBUG="2"
RUN  sudo mkdir -p /opt/output/
ADD  scripts/   /opt/scripts
ADD  templates/ /opt/templates
RUN  /opt/scripts/build_extra
RUN  sudo chown -R agent:runner /opt /home/agent
RUN  sudo chmod -R 775 /opt /home/agent
WORKDIR /opt

FROM terraform_base_image AS package
ADD  .ssh/                      /home/agent/.ssh/
ADD  .azure/                    /home/agent/.azure/
ADD  credentials_provider.conf  /opt/terraform/credentials_provider.conf
ADD  credentials_backend.conf   /opt/terraform/credentials_backend.conf
ADD  environment_variables.conf /opt/environment_variables.conf
ADD  src/                       /opt/src
WORKDIR /opt/src
RUN  sudo chown -R agent:runner /opt /home/agent
RUN  sudo chmod -R 775 /opt /home/agent
RUN  sudo chmod 600 /home/agent/.ssh/config
RUN /opt/scripts/terraform_init

FROM terraform_base_image AS final
COPY --from=package /opt/environment_variables.conf /opt/environment_variables.conf
COPY --from=package /opt/src                        /opt/src
RUN  sudo chown -R agent:runner /opt /home/agent
WORKDIR /opt/src
ENTRYPOINT ["/opt/scripts/entrypoint"]
