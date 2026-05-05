"""Minimal MCP stdio client for testing."""
import json
import subprocess
import sys
from typing import Any


class McpClient:
    def __init__(self, cmd: list[str]):
        self._proc = subprocess.Popen(
            cmd,
            stdin=subprocess.PIPE,
            stdout=subprocess.PIPE,
            stderr=sys.stderr,
        )
        self._next_id = 1
        self._initialize()

    def _send(self, msg: dict) -> None:
        line = json.dumps(msg) + "\n"
        self._proc.stdin.write(line.encode())
        self._proc.stdin.flush()

    def _recv(self) -> dict:
        line = self._proc.stdout.readline()
        return json.loads(line)

    def _initialize(self) -> None:
        self._send({
            "jsonrpc": "2.0",
            "id": self._next_id,
            "method": "initialize",
            "params": {
                "protocolVersion": "2024-11-05",
                "capabilities": {},
                "clientInfo": {"name": "test-client", "version": "1.0"},
            },
        })
        self._next_id += 1
        self._recv()
        self._send({"jsonrpc": "2.0", "method": "notifications/initialized", "params": {}})

    def call_tool(self, name: str, arguments: dict | None = None) -> Any:
        msg_id = self._next_id
        self._next_id += 1
        self._send({
            "jsonrpc": "2.0",
            "id": msg_id,
            "method": "tools/call",
            "params": {"name": name, "arguments": arguments or {}},
        })
        resp = self._recv()
        if "error" in resp:
            raise RuntimeError(f"MCP error: {resp['error']}")
        result = resp["result"]
        content = result.get("content", [])
        if result.get("isError") and content:
            raise RuntimeError(content[0].get("text", "tool error"))
        if content and content[0]["type"] == "text":
            text = content[0]["text"]
            try:
                return json.loads(text)
            except json.JSONDecodeError:
                return text
        return content

    def close(self) -> None:
        self._proc.stdin.close()
        self._proc.wait()
