---
description: Get the combined structured-data report for the site connected to this account.
---

Call the JSON Schema App MCP tool `get_report` to pull the combined structured-data report for the site connected to this account.

Then summarize for the user, leading with a one-line verdict (overall state) per the standard report format (see [[audit-report-format]]):
- The site domain and which platform features are available (`dashboard_scan`, `credits`, `publish`).
- The current plan, its page limit (null = unlimited), and any usage against it.
- AI credit balance, where the platform supports credits.
- The latest MCP scan summary (from `scan_site`) and, where available, the latest dashboard scan run.

Use this **first** to understand the current state of a store before deciding what to scan or fix. If the report shows a stale or missing scan, suggest running `/jsonschemaapp-mcp:scan-site`.
