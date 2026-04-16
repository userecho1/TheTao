---
name: wiki-lint
description: Health-check the wiki for structural and semantic issues.
---

# wiki-lint

Wiki root: `D:\resource\llm-wiki-agent`

## Usage

`lint`

## Checks

**Structural** (grep/glob):
- Orphan pages — no inbound `[[wikilinks]]`
- Broken links — `[[links]]` pointing to nonexistent pages
- Missing entity pages — names in 3+ pages without own page

**Semantic** (read & reason):
- Contradictions — conflicting claims across pages
- Stale summaries — not updated after newer sources
- Data gaps — questions the wiki can't answer; suggest sources

## Output
- Structured markdown lint report
- Ask to save as `wiki/lint-report.md`
- Log `## [YYYY-MM-DD] lint | Wiki health check` to `wiki/log.md`

## Rules
- Repeated runs without content changes produce equivalent findings
- Only write report when user confirms
