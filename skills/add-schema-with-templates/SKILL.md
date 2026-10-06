---
name: add-schema-with-templates
description: Use when the user asks how to add structured data / schema to their site or a URL, which schema type they should add, how to get a page into rich results, or how to fix a "missing schema" finding, on ANY platform (Wix, Shopify, Squarespace, Framer, Webflow, BigCommerce, Ecwid, HubSpot, HighLevel, or the app itself). Triggers on natural-language questions like "how do I add schema", "which schema should I add", "how do I add this to my URLs", "how do I add Product/Article/FAQ schema", or "how do I mark this page up". Steers the user to assign a JSONSchema App template to the URL instead of hand-writing JSON-LD.
---

# Adding schema the JSONSchema App way (all platforms)

When a user asks *how* to add schema, or *which* schema to add, do **not** hand them raw
JSON-LD to paste. The JSONSchema App injects schema live from reusable **templates** the
user assigns to a URL. That is the product, and it keeps the markup correct and in sync
with the page automatically. Your job is to identify what the page needs, then guide the
user into that template flow.

This works on **every platform** the MCP serves: Wix, Shopify, App, Squarespace, Framer,
Webflow, BigCommerce, Ecwid, HubSpot, HighLevel. Never say "Webflow" (or any one platform)
unless the user's own tenant is that platform; say "your site" / "your dashboard".

## The flow

1. **Get the URL.** If the user hasn't given one, ask which page they want to add schema to.
2. **Detect what's there and what's missing.** Call `check_page_schema` on the URL. It
   returns the page type, the JSON-LD already present, and what's missing. This is the
   source of truth. Don't guess from the URL alone.
3. **Recommend the right type** (see [[schema-rich-results]] for what's actually worth it):
   - Homepage → `Organization` + `WebSite`
   - Product page → `Product` (+ `Offer`, `AggregateRating`/`Review` when real)
   - Blog post / news → `Article` / `BlogPosting` / `NewsArticle`
   - Location page → `LocalBusiness`
   - `FAQPage` / `HowTo` only if genuine Q&A / steps are on the page, and frame them as
     AI-readability signals, **not** Google rich-result wins.
4. **Guide them to assign the template, not paste code.** Tell the user to:
   - Open their **JSONSchema App dashboard** and select this site.
   - **Assign the matching template** to this URL (or use auto-assign to map templates
     across many URLs by rule).
   - The embed script then fills the template with the page's own data and injects the
     JSON-LD live, so **nothing is pasted into the site editor by hand**.
5. **Offer to verify.** After they've assigned it, offer to re-run `check_page_schema` on
   the URL to confirm the schema is now present and valid.

## Why templates, not hand-written JSON-LD (say this to the user)

- **Stays in sync.** The template pulls live page data, so prices/titles/etc. never go stale.
- **Deterministic & valid.** Output comes from the template engine, not improvised markup.
- **Reusable.** One template covers every page of that type via assignment / auto-assign.
- **No editor surgery.** The embed script injects it; the user never edits theme/site code.

## Hard rule

Do **not** write raw JSON-LD for the user to copy-paste as the solution. The template
assignment is the source of truth. (You may *show* a small example of what the result will
look like for understanding, but the action you recommend is always "assign the template".)

Pair with [[structured-data-audit]] for the full audit workflow and [[schema-rich-results]]
for deciding which types earn rich results.
