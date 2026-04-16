---
name: wiki-ingest
description: Process a source document into the wiki — extract knowledge, create/update wiki pages, manage inbox transitions.
---

# wiki-ingest

Wiki root: `D:\resource\llm-wiki-agent`

## Usage

`ingest <file>` — file path relative to wiki root, or absolute, or filename in `raw\inbox\pending\`

## Steps

1. Resolve source path (filename → `raw\inbox\pending\`)
2. Inbox file → move `pending → processing`
3. Read source + `wiki\index.md` + `wiki\overview.md`
4. Write/update `wiki\sources\<slug>.md`:
   ```yaml
   ---
   title: "Source Title"
   type: source
   tags: []
   date: YYYY-MM-DD
   source_file: raw/...
   ---
   ## Summary / Key Claims / Key Quotes / Connections / Contradictions
   ```
5. Update `wiki\index.md`, revise `wiki\overview.md` if warranted
6. Create/update entity pages (`wiki\entities\TitleCase.md`)
7. Create/update concept pages (`wiki\concepts\TitleCase.md`)
8. Flag contradictions with existing content
9. Log `ingest | <Title>`
10. Inbox file → move `processing → archived` under `raw\archived\`, log `process_complete`

## Rules
- Upsert only — same slug updates in place, no duplicates
- Re-run safe — idempotent, no duplicate log entries
- Failure → keep in `processing\`, report error
- Source slugs: `kebab-case` matching filename
