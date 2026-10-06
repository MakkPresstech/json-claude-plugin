---
description: Check a site's llms.txt, llms-full.txt, and whether robots.txt blocks AI crawlers.
argument-hint: [domain]
---

Use the JSON Schema App MCP tool `check_llms_txt` to audit a site's AI-crawler readiness.

Domain from the user (optional — if empty, the tool checks the site connected to this account): **$ARGUMENTS**

Steps:
1. Call `check_llms_txt`. If a domain was provided above, pass it as `domain` (e.g. `example.com`); otherwise omit it.
2. Report using the standard report format (see [[audit-report-format]]) — a one-line verdict, then findings grouped by priority, each citing `check_llms_txt`:
   - Whether `llms.txt` and `llms-full.txt` are served, whether they are valid, and the letter grade for each.
   - Whether `robots.txt` blocks major AI crawlers such as GPTBot, ClaudeBot, and PerplexityBot (a blocked crawler the user wants is a P1).
3. Give concrete, prioritized fixes (as the next steps) for anything missing, invalid, or blocked.

Note: this tool is rate-limited to 10 calls/minute and works on any public domain.
