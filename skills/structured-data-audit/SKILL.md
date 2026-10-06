---
name: structured-data-audit
description: Use when the user wants to audit, check, or improve the JSON-LD / Schema.org structured data on their website or a single page — e.g. "audit my store's schema", "why am I not getting rich results", "check my product markup". Drives the JSON Schema App MCP tools (get_report, scan_site, get_scan_status, get_scan_result, check_page_schema) end to end.
---

# Structured-data audit (via JSON Schema App MCP)

All structured-data findings come from the JSON Schema App MCP tools — never invent
schema results, validation errors, or scores. If the tools aren't reachable, tell the
user to connect the server (OAuth) or set their `jsa_live_` API key; don't guess.

## Tools

| Tool | Use |
|------|-----|
| `get_report` | Combined store state: domain, plan/limits, AI credits, latest scans. **Start here.** |
| `scan_site` | Start a background scan of the account's **own** site; returns a `scan_id`. |
| `get_scan_status` | Poll a `scan_id` → `queued` / `running` / `completed` / `failed` + page progress. |
| `get_scan_result` | Per-page findings (types, issues, score) + site totals. Supports `offset`, `limit`, `only_issues`. |
| `check_page_schema` | Inspect one public URL's JSON-LD. Works on **any** site (incl. competitors). 10/min. |

## Workflow

1. **Ground in reality** — call `get_report` first to learn the real domain, plan page
   limit, credits, and whether a recent scan already exists.
2. **Scan the site** — if no recent scan covers it, call `scan_site`, then poll
   `get_scan_status` with the returned `scan_id` until `completed`/`failed`. Back off
   between polls (first poll ~5s, then 5s → 10s → 20s → 30s, ~30s thereafter — never
   tighter than ~5s) and tell the user the running page count. Then read
   `get_scan_result` starting with `only_issues: true` and `limit: 50`, paging with
   `offset` 50 at a time so large scans don't flood context; only request the full
   inventory (`only_issues: false`) when you specifically need non-issue pages. Note if
   the scan is `partial`.
3. **Spot-check key pages** — run `check_page_schema` on the most important URLs (home, a
   top product/collection) to confirm per-page validity and rich-result readiness.
4. **Prioritize** — deliver ONE action plan in the standard report format (see
   [[audit-report-format]]): a one-line verdict, then findings grouped P1/P2/P3 — biggest
   coverage gaps and validation errors first, then rich-result wins, then AI-crawler
   fixes (see [[ai-search-optimization]]) — each citing the tool that reported it.

## Rules

- `scan_site` is for the account's **own** site only. For arbitrary or competitor pages,
  use `check_page_schema`.
- Respect the 10/min limit on `check_page_schema`. If a plan limit is hit, surface the
  upgrade URL the tool returns — don't retry blindly.
- These tools return structured findings, not raw page copy — don't claim to have read
  the page's text.
- Apply the rich-result rules in [[schema-rich-results]] when interpreting findings —
  especially: FAQPage and HowTo no longer earn Google rich results.
- If a page reports the **same warning repeated** for one type (while that type appears
  only once in `schema_types`), it has that many copies of the block — report it as
  "N duplicate `<Type>` blocks detected" and count the property warnings once. See
  [[audit-report-format]].
