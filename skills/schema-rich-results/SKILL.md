---
name: schema-rich-results
description: Reference for how Schema.org / JSON-LD types map to Google rich results and AI readability. Use when interpreting JSON Schema App scan findings, deciding which markup to recommend, or when the user asks which schema types are "worth it", what properties are required, or why FAQPage/HowTo stopped showing rich results.
---

# Schema.org → rich-result reference

Interpretation guidance for findings returned by the JSON Schema App MCP tools
(`check_page_schema`, `get_scan_result`). The tools are the source of truth for what a
page actually has; this skill is how to judge what it's worth.

## The FAQPage / HowTo rule (do not get this wrong)

**FAQPage and HowTo markup no longer produce Google rich results.** The JSON Schema App
tools report them at the `ai_readability` level — useful for AI assistants and LLM
answer engines, not for Google rich snippets.

- Never recommend FAQPage or HowTo as a Google rich-result win.
- If a page already has them, frame them as AI-readability signals only.

## Types that still earn Google rich results

Prioritize fixes on these when the scan shows them missing or invalid:

- **Product** (+ `Offer`, `AggregateRating`, `Review`) — price, availability, review stars.
- **Review / AggregateRating** — star ratings in results.
- **BreadcrumbList** — breadcrumb trail.
- **Article / NewsArticle / BlogPosting** — top-stories / article treatment.
- **Organization / LocalBusiness** — knowledge-panel and local signals.
- **Event**, **Recipe**, **VideoObject**, **JobPosting** — their respective rich cards.

## Reading findings

- **Coverage gaps** (important page types with no relevant markup) are usually the
  highest-impact fix — rank them first.
- **Validation errors** (malformed JSON-LD, wrong types) block rich results entirely —
  fix before chasing optional properties.
- **Missing recommended properties** (e.g. Product without `aggregateRating`) are
  incremental wins — rank after coverage and validity.
- A page's **score** reflects validity + completeness; sort by lowest score + highest
  traffic to pick where to start.

Pair this with [[structured-data-audit]] for the workflow and [[ai-search-optimization]]
for the AI-crawler side.
