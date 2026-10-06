---
description: Check the structured data (JSON-LD / Schema.org) on a single public web page.
argument-hint: <page-url>
---

Use the JSONSchemaApp MCP tool `check_page_schema` to inspect the structured data on this page:

**$ARGUMENTS**

Steps:
1. Call `check_page_schema` with `url` set to the page above (must be http/https and publicly reachable).
2. Summarize using the standard report format (see [[audit-report-format]]): a one-line verdict, then findings grouped P1/P2/P3, each citing `check_page_schema`:
   - Which JSON-LD / Schema.org types were found.
   - Validation issues (P1) or missing recommended properties (P3).
   - Rich-result readiness (coverage gaps as P2).
3. Important: FAQPage and HowTo markup **no longer produce Google rich results**. If they appear, report them only at the `ai_readability` level (useful for AI assistants), and do **not** recommend them for Google rich results.

Notes:
- This tool works on any public URL, so it's also useful for comparing against competitors.
- It is rate-limited to 10 calls/minute. For a whole-site audit of your own store, use `/jsonschemaapp-mcp:scan-site` instead.
