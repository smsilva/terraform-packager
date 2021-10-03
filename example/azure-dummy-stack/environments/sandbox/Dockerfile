FROM azure-dummy-stack:latest
ADD terraform.tfvars /opt/src/terraform.tfvars
ENV TF_VAR_instance_name="dummy-sandbox"
ENV STACK_INSTANCE_NAME=${TF_VAR_instance_name}
