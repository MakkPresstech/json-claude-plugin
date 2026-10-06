---
name: ai-crawler-access
description: Use when the user wants to fix or allow AI-crawler access in robots.txt — e.g. "let ChatGPT/Claude crawl my site", "unblock GPTBot", "what robots.txt do I need for AI search", on any platform (Shopify, WordPress, custom, etc.). Verifies the current state with the JSON Schema App MCP check_llms_txt tool, then gives copy-paste robots.txt snippets.
---

# Fix AI-crawler access in robots.txt (via JSON Schema App MCP)

The server's `fix_ai_crawler_access` starter prompt is **Webflow-only**. This client-side
skill gives the same kind of robots.txt guidance to **every** user (Shopify, WordPress,
custom hosting, etc.). It only produces text the user adds to their own `robots.txt` —
no server change, no deploy.

## Verify before prescribing

Always call `check_llms_txt` first and report which crawlers robots.txt is **currently**
blocking — don't assume. Pass `domain` if the user named one; otherwise omit it to use
the connected account's site. The tool is rate-limited to 10/min.

Only recommend changes for crawlers that are actually blocked, and confirm the user
*wants* AI visibility (some sites intentionally block AI training crawlers — respect
that choice and call it out).

## The major AI crawlers

| User-agent | Operator | Purpose |
|------------|----------|---------|
| `GPTBot` | OpenAI | ChatGPT training/browsing |
| `OAI-SearchBot` | OpenAI | ChatGPT search results |
| `ChatGPT-User` | OpenAI | User-triggered ChatGPT fetches |
| `ClaudeBot` | Anthropic | Claude training/crawling |
| `Claude-Web` / `anthropic-ai` | Anthropic | Claude browsing |
| `PerplexityBot` | Perplexity | Perplexity index |
| `Perplexity-User` | Perplexity | User-triggered Perplexity fetches |
| `Google-Extended` | Google | Gemini / AI Overviews training opt-in |
| `Applebot-Extended` | Apple | Apple AI training opt-in |
| `CCBot` | Common Crawl | Open dataset many models train on |

## Allow all AI crawlers (copy-paste)

Append to `/robots.txt` (keep any existing rules above it):

```
# Allow AI search + assistant crawlers
User-agent: GPTBot
Allow: /

User-agent: OAI-SearchBot
Allow: /

User-agent: ChatGPT-User
Allow: /

User-agent: ClaudeBot
Allow: /

User-agent: anthropic-ai
Allow: /

User-agent: PerplexityBot
Allow: /

User-agent: Perplexity-User
Allow: /

User-agent: Google-Extended
Allow: /

User-agent: Applebot-Extended
Allow: /
```

## Allow AI search but block AI *training*

If the user wants to appear in AI answers but not be used for model training, allow the
search/user agents above and **disallow** the training ones:

```
User-agent: Google-Extended
Disallow: /

User-agent: CCBot
Disallow: /

User-agent: Applebot-Extended
Disallow: /
```

## Platform notes

- **Shopify:** `robots.txt` is generated. Edit via `robots.txt.liquid` in the theme to
  add custom `User-agent` rules; you cannot upload a flat file.
- **WordPress:** a physical `robots.txt` in the web root overrides the virtual one; or
  use an SEO plugin's robots.txt editor.
- **Webflow:** editable in Site settings → SEO → robots.txt (the server's
  `fix_ai_crawler_access` prompt covers this case server-side).
- **Custom/static:** place the file at the domain root so it serves at `/robots.txt`.

## After the fix

- Have the user deploy robots.txt, then re-run `check_llms_txt` to confirm the crawlers
  are no longer blocked.
- Unblocking crawlers is step one; an `llms.txt` index helps them next — hand off to
  [[draft-llms-txt]]. For the broader picture see [[ai-search-optimization]].

## Rules

- Verify with `check_llms_txt` before and after; respect the 10/min limit.
- When reporting the current state, use the standard report format (see
  [[audit-report-format]]): a one-line verdict, blocked-crawler findings cited to
  `check_llms_txt`, then the robots.txt snippet as the next step.
- `robots.txt` directives are advisory — well-behaved crawlers honor them, but it is not
  an access-control mechanism. Say so if the user expects enforcement.
