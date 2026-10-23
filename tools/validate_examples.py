#!/usr/bin/env python3
"""Validate package structure; compilation and gameplay require the matching game build."""
from pathlib import Path
import json

root = Path(__file__).resolve().parents[1]
count = 0
for manifest in sorted((root / "Examples").glob("*/*/Modification.json")):
    package = manifest.parent
    data = json.loads(manifest.read_text())
    assert data["Runtime"] in ("csharp", "lua", "skin"), manifest
    assert data["ApiVersion"] in (1, 2) and data["WorkshopID"] == 0, manifest
    resources = data["Scripts"] + [data["Thumbnail"], data["WorkshopThumbnail"]]
    if data["Runtime"] == "skin":
        assert data["ApiVersion"] == 1 and data["Scripts"] == [], manifest
        resources.append(data["SkinFile"])
        skin = json.loads((package / data["SkinFile"]).read_text())
        assert skin["Version"] == 1 and 0 < len(skin["Items"]) <= 64
        assert len({item["Id"] for item in skin["Items"]}) == len(skin["Items"])
        for item in skin["Items"]:
            assert item["BaseProp"] and len(item["Parts"]) <= 64
            for part in item["Parts"]:
                resources.extend(part[key] for key in ("Texture", "NormalMap") if part.get(key))
            resources.append("Previews/" + item["Id"] + ".png")
    for path in resources:
        relative = Path(path)
        assert not relative.is_absolute() and ".." not in relative.parts, path
        assert (package / relative).is_file(), path
        assert (package / relative).resolve().is_relative_to(package.resolve()), path
    for file in package.rglob("*"):
        assert not file.is_symlink(), file
        if file.is_file():
            assert file.stat().st_size <= 32 * 1024 * 1024, file
            assert file.suffix.lower() not in (".dll", ".exe"), file
    count += 1
assert count == 8, count
print(f"PASS: {count} current example packages have valid manifests and contained resources.")
