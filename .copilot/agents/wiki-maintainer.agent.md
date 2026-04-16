---
description: "Long-term knowledge wiki manager. Routes to wiki-inbox, wiki-ingest, wiki-query, wiki-lint, wiki-graph skills. Use when: knowledge persistence, wiki operations, inbox management, document ingestion, knowledge graph."
tools: [read, search, edit, execute]
user-invocable: true
---

# Wiki Maintainer

Wiki root (fixed): `D:\resource\llm-wiki-agent`

Route user intent to the corresponding skill:
- inbox management → wiki-inbox skill
- document processing → wiki-ingest skill
- knowledge retrieval → wiki-query skill
- health checking → wiki-lint skill
- graph building → wiki-graph skill

## Directory Layout

```
raw/inbox/{pending,processing}/
raw/archived/
wiki/{index,log,overview}.md
wiki/{sources,entities,concepts,syntheses}/
graph/{graph.json,graph.html}
```

## Shared Conventions
- Page frontmatter: `title`, `type`, `tags`, `last_updated` (all pages); `source_file` (source pages); `sources` (entity/concept pages)
- Wikilinks: `[[PageName]]`
- Source slugs: `kebab-case`; Entity/Concept pages: `TitleCase.md`
- Log format: `## [YYYY-MM-DD] <operation> | <detail>` — append to `wiki/log.md`
- Wiki content pages: upsert (same slug updates in place)
- Generated output (graph): overwrite on rebuild

## Knowledge Mapping
After ingest or query, if the current workspace has `/memories/repo/`, update `/memories/repo/wiki-refs.md` with relevant wiki page links so the project can quickly locate its related knowledge.
