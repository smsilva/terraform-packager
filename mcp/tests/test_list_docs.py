"""Test: list_docs returns the full doc catalog."""
import sys
import pathlib
sys.path.insert(0, str(pathlib.Path(__file__).parent))

from mcp_client import McpClient

IMAGE = "silviosilva/terraform-packager-mcp:latest"

client = McpClient(["docker", "run", "--interactive", "--rm", IMAGE])

docs = client.call_tool("list_docs")

assert isinstance(docs, list), f"expected list, got {type(docs)}"
assert len(docs) > 0, "list_docs returned empty list"

for doc in docs:
    assert "path" in doc, f"missing 'path' in {doc}"
    assert "title" in doc, f"missing 'title' in {doc}"
    assert "description" in doc, f"missing 'description' in {doc}"

print(f"OK  list_docs returned {len(docs)} docs")
for d in docs:
    print(f"    {d['path']!r:55} {d['title']}")

client.close()
