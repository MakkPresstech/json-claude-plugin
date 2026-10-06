---
name: draft-llms-txt
description: Use when the user wants to create, write, or draft an llms.txt or llms-full.txt file for their site, e.g. "generate an llms.txt", "write me an llms.txt", "my llms.txt is missing, make one". Produces a valid draft the user can host, using the JSON Schema App MCP tools (check_llms_txt, scan_site, get_scan_result, get_report) for grounding.
---

# Draft an `llms.txt` / `llms-full.txt` (via JSON Schema App MCP)

The JSON Schema App server only **checks** `llms.txt` (via `check_llms_txt`); it does not
generate one. This skill fills that gap on the client side: it drafts a valid file from
what the server already knows about the site. The draft is text the user hosts
themselves. Nothing is deployed to the server, and no server behavior changes.

## Ground the draft in real data first

Do not invent the site's structure. Pull facts from the MCP tools, then draft:

1. `check_llms_txt` shows whether an `llms.txt` / `llms-full.txt` already exists, its
   grade, and what's wrong with it. If one exists, improve it rather than replacing it
   wholesale.
2. `get_report` confirms the real domain and plan.
3. `scan_site` → `get_scan_status` → `get_scan_result`: if a recent scan exists or the
   user is willing to run one, use the discovered pages (home, key products/collections,
   docs, policies) as the real link list. Prefer the highest-scoring, most important
   pages. When polling `get_scan_status`, back off between polls (first poll ~5s, then
   5s → 10s → 20s → 30s, ~30s thereafter). Page through `get_scan_result` with
   `offset`/`limit` (50 at a time); use `only_issues: false` here since you want the full
   page inventory, not just problems.

If a scan isn't available, ask the user for their top pages instead of guessing URLs.

## `llms.txt` format (keep it valid)

`llms.txt` is a Markdown file at the site root (`/llms.txt`). Structure:

```markdown
# Site Name

> One or two sentences describing what the site/business is and offers.

## Core pages
- [Home](https://example.com/): what this page is.
- [Products](https://example.com/products): what this page is.

## Guides
- [Getting started](https://example.com/guides/start): short description.

## Optional
- [Changelog](https://example.com/changelog): lower-priority links go here.
```

Rules for a valid, high-grade file:
- Start with a single `# H1` site title, then a `>` blockquote summary.
- Group links under `##` section headers; every bullet is a `[name](absolute-url):
  description` line with an **absolute** URL.
- Keep it concise. `llms.txt` is an index, not a content dump. Put the full content
  into `llms-full.txt` only after `llms.txt` is solid.
- Use real, reachable URLs from the scan. Never fabricate paths.

## After drafting

- Show the draft in a code block and tell the user to host it at `/llms.txt`.
- Offer to run `check_llms_txt` again after they deploy it to confirm the grade improved.
- If robots.txt is blocking AI crawlers, drafting `llms.txt` won't help until that's
  fixed, so hand off to [[ai-crawler-access]] first.

## Rules

- Respect the 10/min limit on `check_llms_txt`.
- If a plan limit is hit on a scan, surface the upgrade URL the tool returns.
- See [[ai-search-optimization]] for how this fits overall AI-search readiness.
