# Terraform Packager MCP

An MCP server that exposes Terraform Packager documentation as searchable, readable content — no LLM required server-side.

## Tools

| Tool | Description |
|------|-------------|
| `list_docs` | List all available documentation files with title and description |
| `read_doc(path)` | Return the full content of a documentation file |
| `search_docs(query)` | Keyword search across all docs; returns matching snippets with ±3 lines of context |

The documentation index is built at image build time. The agent using this MCP is responsible for reasoning over the returned content.

## Using in a local project

Run in the project root:

```bash
claude mcp add terraform-packager \
  --scope project \
  -- docker run \
  -i \
  --rm \
  -e DEBUG \
  -e LOG_FORMAT=json \
  silviosilva/terraform-packager-mcp:latest
```

This creates a `.mcp.json` in your project root. Alternatively, create it manually:

```json
{
  "mcpServers": {
    "terraform-packager": {
      "command": "docker",
      "args": [
        "run",
        "-i",
        "--rm",
        "-e", "DEBUG",
        "-e", "LOG_FORMAT=json",
        "silviosilva/terraform-packager-mcp:latest"
      ]
    }
  }
}
```

No API key required.

## Environment variables

| Variable | Required | Description |
|----------|----------|-------------|
| `DEBUG` | No | Verbosity: `0` = off, `1` = info, `2` = debug |
| `LOG_FORMAT` | No | Log format: `text` (default) or `json` (JSON Lines) |

## Building and running locally

```bash
# Build the image
make mcp-build

# Run standalone (for testing)
make mcp-run

# Push to registry
make mcp-push
```

The default image tag is `silviosilva/terraform-packager-mcp:latest`. Override with:

```bash
make mcp-build IMAGE=myrepo/terraform-packager-mcp:v1.0.0
```
