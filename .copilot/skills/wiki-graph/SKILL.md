---
name: wiki-graph
description: Build a knowledge graph from wiki pages and visualize it.
---

# wiki-graph

Wiki root: `D:\resource\llm-wiki-agent`

## Usage

`build graph`

## Steps

1. Try: `python D:\resource\llm-wiki-agent\tools\build_graph.py --open`
2. Fallback (manual build):
   - **Scope**: only scan content directories — `wiki/{sources,entities,concepts,syntheses}/`
   - Detect unknown directories under `wiki/` (ignore known infra: `index.md`, `log.md`, `overview.md`, `lint-report.md`) → warn in output: `⚠ Unknown directory: wiki/<name>/ — not included in graph`
   - Scan all `[[wikilinks]]` across scoped pages
   - Build nodes: one per page — `{id, label, type}` from frontmatter
   - Build edges: one per `[[wikilink]]` — `{source, target}`, tagged `EXTRACTED`
   - Infer implicit relationships (co-citation: two nodes referenced by the same page) → tag `INFERRED` with confidence (co-citation count / max citation count); confidence < 0.3 → tag `AMBIGUOUS`, do not generate edge
3. Write `graph/graph.json` with `{nodes, edges, built: date}`
4. Write `graph/graph.html` — self-contained vis.js page (colored by type, INFERRED edges dashed, interactive, searchable)
5. Log `## [YYYY-MM-DD] graph | Knowledge graph rebuilt` to `wiki/log.md`

## Output
- Summary: node count, edge count (extracted/inferred), type breakdown, hub nodes (most linked)
- Warnings for unknown directories not included in graph

## Rules
- Generated output — overwrite `graph.json` and `graph.html` on rebuild (not wiki content, no upsert needed)
- Stable output for unchanged wiki input
