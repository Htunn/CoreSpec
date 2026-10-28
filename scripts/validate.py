#!/usr/bin/env python3
"""Validate CoreSpec agents, skills, templates, and workflow consistency."""
from __future__ import annotations

import re
import sys
from pathlib import Path

import yaml

ROOT = Path(__file__).resolve().parent.parent
errors: list[str] = []


def err(msg: str) -> None:
    errors.append(msg)


def front_matter(path: Path) -> dict:
    m = re.match(r"---\n(.*?)\n---\n", path.read_text(encoding="utf-8"), re.S)
    if not m:
        err(f"{path.relative_to(ROOT)}: missing YAML front-matter")
        return {}
    try:
        data = yaml.safe_load(m.group(1))
    except yaml.YAMLError as e:
        err(f"{path.relative_to(ROOT)}: invalid YAML front-matter ({e})")
        return {}
    return data if isinstance(data, dict) else {}


def need(path: Path, fm: dict, keys: list[str]) -> None:
    for k in keys:
        if not fm.get(k):
            err(f"{path.relative_to(ROOT)}: front-matter missing '{k}'")


agents = {p.stem: p for p in sorted((ROOT / "agents").glob("*.md"))}
skills = {p.parent.name: p for p in sorted((ROOT / "copilot/skills").glob("*/SKILL.md"))}

for name, p in agents.items():
    fm = front_matter(p)
    need(p, fm, ["name", "description", "model", "tools"])
    if fm.get("name") != name:
        err(f"{p.relative_to(ROOT)}: name '{fm.get('name')}' does not match file name")
for name, p in skills.items():
    fm = front_matter(p)
    need(p, fm, ["name", "description", "license", "metadata"])
    if fm.get("name") != name:
        err(f"{p.relative_to(ROOT)}: name '{fm.get('name')}' does not match directory name")

for name in sorted(set(agents) ^ set(skills)):
    err(f"'{name}' exists as {'agent' if name in agents else 'skill'} only; agents and skills must be paired")

for p in [*agents.values(), *skills.values()]:
    if "## Git Commit Policy" not in p.read_text(encoding="utf-8"):
        err(f"{p.relative_to(ROOT)}: missing '## Git Commit Policy' section")

# Every top-level section of the spec template must appear in the roles that embed it.
template = (ROOT / "templates/SPEC-template.md").read_text(encoding="utf-8")
sections = re.findall(r"^## (.+)$", template, re.M)
for role in ("software-architect", "product-manager"):
    for p in (agents.get(role), skills.get(role)):
        if p is None:
            continue
        text = p.read_text(encoding="utf-8")
        for s in sections:
            if f"## {s}" not in text:
                err(f"{p.relative_to(ROOT)}: spec template section '## {s}' missing")

# The orchestrator must define the same phases in the agent, the skill, and the README.
def phases(text: str) -> set[str]:
    return set(re.findall(r"^#{2,3} Phase (\d+)", text, re.M))

sd_agent = phases((ROOT / "agents/spec-driver.md").read_text(encoding="utf-8"))
sd_skill = phases((ROOT / "copilot/skills/spec-driver/SKILL.md").read_text(encoding="utf-8"))
if sd_agent != sd_skill:
    err(f"spec-driver phases differ: agent {sorted(sd_agent)} vs skill {sorted(sd_skill)}")
readme = (ROOT / "README.md").read_text(encoding="utf-8")
readme_phases = set(re.findall(r"^Phase (\d+)\s", readme, re.M))
if readme_phases != sd_agent:
    err(f"README phase list {sorted(readme_phases)} differs from spec-driver {sorted(sd_agent)}")

# Roles referenced in the README must be real and complete.
m = re.search(r"for all (\d+) roles", readme)
if m and int(m.group(1)) != len(skills):
    err(f"README says {m.group(1)} roles but {len(skills)} skills exist")
for name in agents:
    if f"`{name}`" not in readme:
        err(f"README roles table does not mention '{name}'")

if errors:
    print("\n".join(f"ERROR: {e}" for e in errors))
    sys.exit(1)
print(f"ok: {len(agents)} agents, {len(skills)} skills, {len(sd_agent)} workflow phases")
