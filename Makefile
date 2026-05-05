IMAGE ?= silviosilva/terraform-packager-mcp:latest
MCP_LOGS_DIR ?= $(HOME)/.terraform-packager/mcp/logs

mcp-build:
	docker build --file Dockerfile.mcp --tag $(IMAGE) .

mcp-run:
	mkdir --parents $(MCP_LOGS_DIR)
	docker run --interactive --rm \
		--env DEBUG \
		--env LOG_FORMAT \
		--volume $(MCP_LOGS_DIR):/logs \
		$(IMAGE)

mcp-push:
	docker push $(IMAGE)
