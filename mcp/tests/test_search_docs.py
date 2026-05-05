"""Test: search_docs returns relevant snippets for various queries."""
import sys
import pathlib
sys.path.insert(0, str(pathlib.Path(__file__).parent))

from mcp_client import McpClient

IMAGE = "silviosilva/terraform-packager-mcp:latest"

client = McpClient(["docker", "run", "--interactive", "--rm", IMAGE])

cases = [
    ("stackbuild",   1,  "should find stackbuild references"),
    ("backend",      1,  "should find backend references"),
    ("provider",     1,  "should find provider references"),
    ("credentials",  1,  "should find credentials references"),
    ("xyzzy_no_match_expected", 0, "unknown term should return empty"),
]

all_ok = True
for query, min_results, description in cases:
    results = client.call_tool("search_docs", {"query": query})
    assert isinstance(results, list), f"expected list for query={query!r}"
    ok = len(results) >= min_results
    status = "OK " if ok else "FAIL"
    print(f"{status} search_docs query={query!r} → {len(results)} matches  ({description})")
    if not ok:
        all_ok = False
    else:
        for r in results[:2]:
            snippet_first = r["snippet"].splitlines()[0]
            print(f"    [{r['path']} L{r['line']}] {snippet_first}")

client.close()

if not all_ok:
    sys.exit(1)
