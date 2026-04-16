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
   - Scan all `[[wikilinks]]` across `wiki\`
   - Build nodes (one per page: id, label, type from frontmatter)
   - Build edges (one per link, tagged `EXTRACTED`)
   - Infer implicit relationships → tag `INFERRED` with confidence 0.0–1.0; low confidence → `AMBIGUOUS`
3. Write `graph\graph.json` with `{nodes, edges, built: date}`
4. Write `graph\graph.html` — self-contained vis.js page (colored by type, interactive, searchable)
5. Log `graph | Knowledge graph rebuilt`

## Output
- Summary: node count, edge count, type breakdown, hub nodes

## Rules
- Overwrite `graph.json` and `graph.html` on rebuild, no version fanout
- Stable output for unchanged wiki input
