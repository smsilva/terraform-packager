"""Test: read_doc returns file content by path."""
import sys
import pathlib
sys.path.insert(0, str(pathlib.Path(__file__).parent))

from mcp_client import McpClient

IMAGE = "silviosilva/terraform-packager-mcp:latest"

client = McpClient(["docker", "run", "--interactive", "--rm", IMAGE])

# get a valid path first
docs = client.call_tool("list_docs")
first_path = docs[0]["path"]

content = client.call_tool("read_doc", {"path": first_path})

assert isinstance(content, str), f"expected str, got {type(content)}"
assert len(content) > 10, f"content too short: {content!r}"

print(f"OK  read_doc path={first_path!r}")
print(f"    {len(content)} chars, first line: {content.splitlines()[0]!r}")

# also test with a short suffix path
content2 = client.call_tool("read_doc", {"path": "getting-started.md"})
assert "getting" in content2.lower() or len(content2) > 10
print(f"OK  read_doc path='getting-started.md' → {len(content2)} chars")

# test nonexistent path raises an error
try:
    client.call_tool("read_doc", {"path": "does-not-exist.md"})
    print("FAIL read_doc nonexistent path should have raised error")
    sys.exit(1)
except RuntimeError as e:
    print(f"OK  read_doc nonexistent path raised error as expected: {e}")

client.close()
