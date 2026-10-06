---
name: audit-report-format
description: Reference for the standard shape of every JSONSchemaApp audit answer — a one-line verdict, findings grouped by P1/P2/P3 priority, each citing the tool that produced it. Use when reporting results from any JSONSchemaApp MCP tool (get_report, scan_site, get_scan_result, check_page_schema, check_llms_txt) so every audit reads the same way.
---

# Standard audit report format

Every audit, scan summary, page check, or crawler-access report built on the
JSONSchemaApp MCP tools should use this one shape, so results read consistently and are
always traceable back to real tool output.

## The shape

1. **Verdict** — a single line summarizing overall state
   (e.g. "Good schema coverage, but 2 blocking validation errors and GPTBot is blocked").
2. **Findings by priority** — grouped, most urgent first. Omit a group if it's empty.
   - **P1 — blocking:** validation errors, missing core markup, or blocked crawlers that
     prevent results entirely.
   - **P2 — high value:** coverage gaps on important pages and rich-result wins within reach.
   - **P3 — incremental:** optional recommended properties and nice-to-haves.
   Each finding states **what**, **where** (page URL or file), and **which tool reported
   it** (e.g. "`get_scan_result`: Product on /shoes missing `aggregateRating`").
3. **Next steps** — the concrete fixes to make, in the same priority order.

## Rules

- **Evidence before assertions.** Every finding must trace to a tool result — never
  invent a score, a validation error, or a severity. If a tool wasn't called, don't
  report on what it would have found.
- If a severity is genuinely unclear, say so instead of guessing a priority.
- Keep the verdict honest: if a scan was `partial` or a tool call failed, state that in
  the verdict rather than implying full coverage.
- Apply the interpretation rules in [[schema-rich-results]] when assigning priority —
  especially: FAQPage and HowTo are `ai_readability`-level only, never a P-ranked Google
  rich-result win.

## Repeated identical warnings = duplicate JSON-LD blocks

`get_scan_result` records issues **once per JSON-LD block**, while the `schema_types`
list is de-duplicated. So when a single page reports the *same* warning more than once for
the same type (e.g. `brand` missing on `Product` listed twice) but the type appears only
once in `schema_types`, the page almost certainly carries **that many copies of the block**
— e.g. two `Product` blocks. (This was verified on real Wix pages, not a tool bug.)

When you see this pattern:

- Report it explicitly as a finding: **"N duplicate `<Type>` blocks detected on `<page>`"**,
  citing `get_scan_result`. Duplicate structured-data blocks for one entity mean search
  engines see conflicting/repeated entities, so this is usually **P2** (worth consolidating
  to a single block).
- Count the underlying property warnings **once**, not once per duplicate — say "missing
  `brand`/`sku` (on each of the N blocks)" rather than listing them N times, so the report
  isn't inflated.
- State it as an inference ("appears to be N copies of the block"), since the tool doesn't
  label blocks individually — don't assert a count the data can't confirm.

Used by [[structured-data-audit]], [[ai-search-optimization]], [[ai-crawler-access]], and
the `/jsonschemaapp-mcp:*` commands.
