---
description: Scan the structured data of the whole site connected to this account, then report the findings.
argument-hint: [max_pages]
---

Run a full structured-data scan of the site connected to this account using the JSON Schema App MCP tools, then report the findings.

Optional page cap from the user (defaults to 100 if empty, capped by the account's plan): **$ARGUMENTS**

Steps:
1. Call `scan_site`. If a `max_pages` value was provided above, pass it; otherwise omit it. This returns a `scan_id` immediately — the scan runs in the background.
2. Poll `get_scan_status` with that `scan_id` until `status` is `completed` or `failed`. Don't hammer it: wait ~5s before the first poll, then back off 5s → 10s → 20s → 30s and keep polling at ~30s intervals after that. Tell the user the running page count as it progresses.
3. When complete, read `get_scan_result` with the `scan_id`. Start with `only_issues: true` and `limit: 50`, then page with `offset` (50 at a time) — this keeps large scans from flooding context. Only call it again with `only_issues: false` if you specifically need the full page inventory (not just the problems).
4. Summarize using the standard report format (see [[audit-report-format]]): a one-line verdict, then findings grouped P1/P2/P3 — site-level totals, schema types found, the most common issues, and the lowest-scoring pages — each citing `get_scan_result`. Note if the scan was `partial` (hit its time limit).

Notes:
- `scan_site` only works on **your own** site. To check any single page (including competitors), use `/jsonschemaapp-mcp:check-page`.
- Only one scan runs at a time per store, and daily scans are limited by plan. If you hit a plan limit, surface the upgrade URL the tool returns.
- FAQPage and HowTo no longer produce Google rich results — report them at `ai_readability` level only, never as Google rich-result recommendations.
- If a page shows the **same warning repeated** for one type (but that type is listed only once in `schema_types`), it carries that many copies of the block. Report it as "N duplicate `<Type>` blocks detected on `<page>`" (usually P2 — consolidate to one block) and count the property warnings once rather than per copy. See [[audit-report-format]].
