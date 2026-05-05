import json
import logging
import os
import pathlib
import sys

from fastmcp import FastMCP

_DEBUG = int(os.environ.get("DEBUG", "0"))
_LOG_FORMAT = os.environ.get("LOG_FORMAT", "text").lower()
_LOG_DIRECTORY = os.environ.get("LOG_DIRECTORY", "/tmp/logs")
_LOG_DIR = pathlib.Path(_LOG_DIRECTORY)
_LOG_DIR.mkdir(exist_ok=True)

_log_level = logging.DEBUG if _DEBUG >= 2 else logging.INFO if _DEBUG >= 1 else logging.WARNING


class _JsonFormatter(logging.Formatter):
    def format(self, record: logging.LogRecord) -> str:
        return json.dumps({
            "ts": self.formatTime(record),
            "level": record.levelname,
            "logger": record.name,
            "msg": record.getMessage(),
        })


_formatter = _JsonFormatter() if _LOG_FORMAT == "json" else logging.Formatter("%(asctime)s %(levelname)s %(message)s")

_file_handler = logging.FileHandler(_LOG_DIR / "server.log")
_file_handler.setFormatter(_formatter)

_stderr_handler = logging.StreamHandler(sys.stderr)
_stderr_handler.setFormatter(_formatter)

logging.root.setLevel(_log_level)
logging.root.addHandler(_file_handler)
logging.root.addHandler(_stderr_handler)

_log = logging.getLogger("mcp")

BASE = pathlib.Path(__file__).parent
_INDEX_PATH = BASE / "docs_index.json"

_index: list[dict] = json.loads(_INDEX_PATH.read_text()) if _INDEX_PATH.exists() else []
_log.info("loaded %d docs from index", len(_index))

mcp = FastMCP(
    "terraform-packager-docs",
    instructions=(
        "Use this server to look up documentation about Terraform Packager — "
        "a tool that packages Terraform code into self-contained Docker images called Stacks. "
        "IMPORTANT: Before performing any Terraform Packager task (creating a stack, building, running, "
        "configuring backends or providers), always call list_docs first and read the relevant docs. "
        "Topics covered: stack project format (stack.yaml, src/ layout), stackbuild (building Stack images), "
        "stackrun (running terraform plan/apply/destroy inside containers), backends, providers, "
        "credentials, hooks, variables, and SSH configuration."
    ),
)


@mcp.tool
def list_docs() -> list[dict]:
    """List all available documentation files with their title and description."""
    return [{"path": d["path"], "title": d["title"], "description": d["description"]} for d in _index]


@mcp.tool
def read_doc(path: str) -> str:
    """Return the full content of a documentation file. Use the path from list_docs."""
    _log.debug("read_doc path=%r", path)
    for doc in _index:
        if doc["path"] == path or doc["path"].endswith(path):
            return doc["content"]
    target = BASE / path
    if target.exists():
        return target.read_text()
    raise FileNotFoundError(f"doc not found: {path!r}")


@mcp.tool
def search_docs(query: str) -> list[dict]:
    """
    Search documentation for a keyword or phrase.
    Returns matching snippets (±3 lines of context) with file path and line number.
    """
    _log.debug("search_docs query=%r", query)
    results = []
    terms = query.lower().split()

    for doc in _index:
        lines = doc["content"].splitlines()
        for i, line in enumerate(lines):
            lower = line.lower()
            if all(t in lower for t in terms):
                start = max(0, i - 3)
                end = min(len(lines), i + 4)
                results.append({
                    "path": doc["path"],
                    "title": doc["title"],
                    "line": i + 1,
                    "snippet": "\n".join(lines[start:end]),
                })

    _log.info("search_docs query=%r matches=%d", query, len(results))
    return results


if __name__ == "__main__":
    transport = os.environ.get("MCP_TRANSPORT", "stdio")
    _log.info("starting terraform-packager-docs MCP (DEBUG=%d, transport=%s)", _DEBUG, transport)
    mcp.run(transport=transport)
