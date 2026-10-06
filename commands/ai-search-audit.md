---
description: Full AI-search readiness audit of your site — structured data, scan findings, and AI-crawler access.
argument-hint: [domain]
---

Run a complete AI-search readiness audit of the site connected to this account, combining every JSON Schema App MCP tool. This mirrors the server's `optimize_for_ai_search` flow.

Optional domain override from the user: **$ARGUMENTS**

Steps:
1. **State of the store** — call `get_report` to establish the site domain, plan/limits, and the latest scan summary.
2. **AI-crawler access** — call `check_llms_txt` (pass the domain above if given) to check `llms.txt` / `llms-full.txt` and whether robots.txt blocks GPTBot, ClaudeBot, PerplexityBot, etc.
3. **Site-wide structured data** — if the report shows no recent scan, run `scan_site`, then poll `get_scan_status` with backoff (first poll ~5s, then 5s → 10s → 20s → 30s, ~30s thereafter) until complete. Read `get_scan_result` with `only_issues: true` and `limit: 50`, paging with `offset`; only pull the full inventory (`only_issues: false`) if you actually need it. Otherwise summarize the existing scan.
4. **Spot-check key pages** — for the most important pages (home, a top product/collection), call `check_page_schema` to confirm JSON-LD validity and rich-result readiness.

Then deliver one prioritized action plan in the standard report format (see [[audit-report-format]]): a one-line verdict, then findings grouped P1/P2/P3 — each citing the tool it came from — covering structured-data coverage and validity, rich-result readiness, and AI-crawler access.

Reminder: FAQPage and HowTo no longer produce Google rich results — treat them as `ai_readability`-level only, never as Google rich-result recommendations.
