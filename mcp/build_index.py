"""Generate docs_index.json from the docs/ directory at image build time."""
import json
import pathlib
import re
import sys


def extract_meta(path: pathlib.Path) -> dict:
    text = path.read_text()
    lines = text.splitlines()

    title = path.stem.replace("-", " ").title()
    for line in lines:
        m = re.match(r"^#\s+(.+)", line)
        if m:
            title = m.group(1).strip()
            break

    description = ""
    in_code_block = False
    for line in lines:
        stripped = line.strip()
        if stripped.startswith("```"):
            in_code_block = not in_code_block
            continue
        if in_code_block or not stripped:
            continue
        if re.match(r"^#{1,6}\s", stripped) or stripped.startswith("|"):
            continue
        description = stripped
        break

    return {
        "path": str(path),
        "title": title,
        "description": description,
        "content": text,
    }


def build_index(docs_dir: pathlib.Path) -> list[dict]:
    index = []
    for md in sorted(docs_dir.rglob("*.md")):
        if "superpowers" in md.parts:
            continue
        index.append(extract_meta(md))
    return index


if __name__ == "__main__":
    docs_dir = pathlib.Path(sys.argv[1]) if len(sys.argv) > 1 else pathlib.Path("skills/terraform-packager/docs")
    out = pathlib.Path(sys.argv[2]) if len(sys.argv) > 2 else pathlib.Path("docs_index.json")
    index = build_index(docs_dir)
    out.write_text(json.dumps(index, indent=2))
    print(f"Indexed {len(index)} files → {out}", file=sys.stderr)
