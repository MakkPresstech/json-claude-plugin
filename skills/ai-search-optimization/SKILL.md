---
name: ai-search-optimization
description: Use when the user asks about AI search visibility, GEO, llms.txt / llms-full.txt, or whether AI crawlers (GPTBot, ClaudeBot, PerplexityBot, Google-Extended) can access their site. Drives the JSONSchemaApp MCP check_llms_txt tool and turns its findings into prioritized fixes.
---

# AI-search / crawler-access optimization (via JSONSchemaApp MCP)

Use the `check_llms_txt` MCP tool for all crawler-access findings — don't assert what a
site serves without calling it. The tool works on any public domain and is rate-limited
to **10 calls/minute**.

## What `check_llms_txt` returns

- Whether `llms.txt` and `llms-full.txt` are served, whether each is **valid**, and a
  **letter grade** per file.
- Whether `robots.txt` **blocks major AI crawlers** — GPTBot (OpenAI), ClaudeBot
  (Anthropic), PerplexityBot, Google-Extended, and others.

## Workflow

1. Call `check_llms_txt`. Pass `domain` (e.g. `example.com`) if the user named one;
   otherwise omit it to check the site connected to the account.
2. Report in the standard report format (see [[audit-report-format]]) — a one-line
   verdict, then findings by priority, each citing `check_llms_txt`: llms.txt /
   llms-full.txt presence + validity + grade, and which AI crawlers (if any) robots.txt
   is blocking.
3. Give concrete, prioritized fixes (the next-steps section):
   - **Unblock crawlers first** — if robots.txt blocks GPTBot/ClaudeBot/PerplexityBot and
     the user wants AI visibility, that's the top fix.
   - **Add/repair `llms.txt`** — a concise, valid index of the site's key content.
   - **Add `llms-full.txt`** — the fuller content dump — once `llms.txt` is solid.

## How this fits the bigger picture

AI-crawler access is one leg of AI-search readiness; structured data is the other.
`ai_readability`-level markup (including FAQPage/HowTo — see [[schema-rich-results]])
only helps if crawlers can actually reach the pages. For a full audit that combines
both, use [[structured-data-audit]] and run `check_llms_txt` alongside the site scan.

## Rules

- Respect the 10/min limit; don't hammer the tool across many domains in a loop.
- If a plan limit is hit, surface the upgrade URL the tool returns.
