---
name: wiki-inbox
description: Manage the wiki inbox — list pending documents or add new ones for processing.
---

# wiki-inbox

Wiki root: `D:\resource\llm-wiki-agent`

## Commands

### list
Scan `raw\inbox\pending\` → output codemap table (file, type, size, modified, priority, recommended action).
Read-only — no file writes, no log writes.

### add \<file\>
- Resolve path (absolute, or relative under wiki root)
- Copy source file into `raw\inbox\pending\`
- Same filename exists with identical content → no-op
- Same filename exists with different content → report conflict, don't overwrite
- Log `inbox_add | <filename>` to `wiki\log.md` (only on new add)

## Rules
- Inbox state transitions (`pending → processing → archived`) owned by wiki-ingest only
- This skill never moves files between inbox subdirectories
