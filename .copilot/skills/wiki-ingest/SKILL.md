---
name: wiki-ingest
description: Process a source document into the wiki — extract knowledge, create/update wiki pages, manage inbox transitions.
---

# wiki-ingest

Wiki root: `D:\resource\llm-wiki-agent`

## Usage

`ingest <file>` — file path relative to wiki root, or absolute, or filename in `raw/inbox/pending/`

## Steps

1. Resolve source path (filename → `raw/inbox/pending/`)
2. Inbox file → move `pending/ → processing/`
3. Read source + `wiki/index.md` + `wiki/overview.md`
4. Derive slug: `kebab-case` from filename (strip extension, lowercase, spaces/underscores → hyphens)
5. Write/update `wiki/sources/<slug>.md`:
   ```yaml
   ---
   title: "Source Title"
   type: source
   tags: []
   source_file: raw/...
   last_updated: YYYY-MM-DD
   ---
   ## Summary / Key Claims / Key Quotes / Connections / Contradictions
   ```
6. Update `wiki/index.md`, revise `wiki/overview.md` if warranted
7. Create/update entity pages (`wiki/entities/TitleCase.md`) — frontmatter uses `sources: [<slug>]`, `last_updated`
8. Create/update concept pages (`wiki/concepts/TitleCase.md`) — frontmatter uses `sources: [<slug>]`, `last_updated`
9. Flag contradictions with existing content
10. Log `## [YYYY-MM-DD] ingest | <Title>` to `wiki/log.md`
11. Inbox file → move `processing/ → raw/archived/`
12. Log `## [YYYY-MM-DD] archive | <filename>` to `wiki/log.md`

## Rules
- Upsert only — same slug updates in place, no duplicates
- Re-run safe — idempotent, no duplicate log entries
- Failure → keep in `processing/`, report error; user resolves then re-runs
- Source slugs: `kebab-case` matching filename (validate before write)
- Entity/Concept pages: `TitleCase.md` (validate before write)
