---
name: wiki-query
description: Search the wiki and synthesize an answer with citations.
---

# wiki-query

Wiki root: `D:\resource\llm-wiki-agent`

## Usage

`query: <question>`

## Steps

1. Read `wiki/index.md` → identify relevant pages (up to ~10)
2. Read those pages
3. Synthesize answer with `[[PageName]]` wikilink citations
4. Include `## Sources` section listing pages drawn from
5. Ask to save as `wiki/syntheses/<slug>.md` (slug: `kebab-case` from question keywords)
   ```yaml
   ---
   title: "<question summary>"
   type: synthesis
   tags: []
   sources: [<page-slugs-cited>]
   last_updated: YYYY-MM-DD
   ---
   ```
6. If current workspace has `/memories/repo/`, update `/memories/repo/wiki-refs.md` with cited wiki page links

## Rules
- Read-only unless user confirms saving synthesis
- Overwrite same slug on repeated saves, no duplicates
- Log `## [YYYY-MM-DD] query | <question summary>` to `wiki/log.md` only when synthesis is saved
