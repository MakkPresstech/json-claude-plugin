# JSON Schema App MCP: Claude Code Plugin

Connects Claude to the **JSON Schema App MCP server** (`https://mcp.jsonschemaapp.com/mcp`) so you can check structured data (JSON-LD / Schema.org), scan your site, audit AI-crawler access, and read your structured-data report, right from Claude.

This plugin is a **client**: it only connects to the hosted MCP server. It does not change or redeploy any server code, so nothing in the existing MCP/app flow is affected.

## What's inside

```
json-claude-plugin/
├── .claude-plugin/
│   ├── plugin.json              # Plugin manifest
│   └── marketplace.json         # Marketplace entry so it installs via /plugin
├── .mcp.json                    # Connects to https://mcp.jsonschemaapp.com/mcp (OAuth)
├── commands/                    # Slash commands (one per workflow)
│   ├── check-page.md            # /jsonschemaapp-mcp:check-page   -> check_page_schema
│   ├── scan-site.md             # /jsonschemaapp-mcp:scan-site    -> scan_site + status + result
│   ├── report.md                # /jsonschemaapp-mcp:report       -> get_report
│   ├── check-llms.md            # /jsonschemaapp-mcp:check-llms   -> check_llms_txt
│   └── ai-search-audit.md       # /jsonschemaapp-mcp:ai-search-audit (full audit, all tools)
├── agents/
│   └── schema-auditor.md        # Subagent that drives a full audit end to end
├── skills/                      # Model-invoked skills (auto-activate from natural language)
│   ├── structured-data-audit/   # Full audit workflow over the MCP tools
│   ├── schema-rich-results/     # Which Schema.org types earn rich results (FAQPage/HowTo rule)
│   ├── ai-search-optimization/  # llms.txt + AI-crawler access via check_llms_txt
│   ├── draft-llms-txt/          # Draft a valid llms.txt from scan data (client-side)
│   ├── ai-crawler-access/       # robots.txt snippets to allow AI crawlers (any platform)
│   └── audit-report-format/     # Canonical report shape (verdict + P1/P2/P3 + tool citations)
├── hooks/
│   ├── hooks.json               # SessionStart connectivity reminder
│   └── connectivity-check.sh    # Non-blocking "connect the server first" notice
└── README.md
```

## MCP tools exposed by the server

| Tool | What it does |
|------|--------------|
| `check_page_schema` | Structured data of one public page (any URL). 10/min. |
| `scan_site` | Start a background scan of your own site; returns a `scan_id`. |
| `get_scan_status` | Poll a scan's progress by `scan_id`. |
| `get_scan_result` | Per-page findings + site totals for a completed scan. |
| `check_llms_txt` | `llms.txt` / `llms-full.txt` validity + AI-crawler robots.txt check. 10/min. |
| `get_report` | Combined report: domain, plan/limits, AI credits, latest scans. |

> Webflow tenants also get server-side starter prompts (`optimize_for_ai_search`,
> `fix_ai_crawler_access`, `check_schema_coverage`, `assign_schema_template`) which
> surface automatically in Claude's prompt picker when connected as a Webflow store.

## Authentication

The server supports two ways in; the plugin ships with the first:

1. **OAuth (default).** `.mcp.json` points at the HTTP endpoint with no credentials.
   On first use Claude discovers the OAuth flow automatically (via the server's
   `401` + `WWW-Authenticate` / `/.well-known/oauth-protected-resource`) and prompts
   you to connect. Nothing to configure.

2. **API key (optional).** If you have a `jsa_live_…` key, Claude Code prompts you for
   it when the plugin is enabled, through the plugin's **API key** option. You can also
   set or clear it later in `/config`.

   The key is declared as a `userConfig` option in `plugin.json`:

   ```json
   {
     "userConfig": {
       "api_key": {
         "type": "string",
         "title": "API key",
         "description": "Optional JSON Schema App API key (starts with jsa_live_). Leave empty to sign in with OAuth instead.",
         "sensitive": true
       }
     }
   }
   ```

   Because the option is `sensitive`, Claude Code masks the input and stores the value in
   your operating system's credential store, not in `settings.json`. The plugin's
   `.mcp.json` references it as `${user_config.api_key}` in the Authorization header, so
   the key never appears in the repository or in your shell environment. There is no
   environment variable to export and nothing to keep out of version control.

## Install

**Via marketplace (recommended).** This directory ships a `.claude-plugin/marketplace.json`,
so it installs with `/plugin`:

```
/plugin marketplace add MakkPresstech/json-claude-plugin
/plugin install jsonschemaapp-mcp@jsonschemaapp
```

**Local dev.** Load the directory directly without a marketplace:

```bash
git clone https://github.com/MakkPresstech/json-claude-plugin.git
claude --plugin-dir ./json-claude-plugin
```

Verify the connection with `/mcp` (the `jsonschemaapp` server should list as connected),
then run `/jsonschemaapp-mcp:report` to confirm the tools respond. On session start the
plugin's connectivity hook prints a short reminder to complete OAuth first. See
[Fewer permission prompts](#fewer-permission-prompts).

## Fewer permission prompts

Each `mcp__plugin_jsonschemaapp-mcp_jsonschemaapp__*` tool call prompts for approval by
default. To let the six read-only tools run without interruption, add them to your **project** `.claude/settings.json`
(or user settings). Nothing here changes the server. It only pre-approves client-side
tool calls you'd otherwise approve by hand:

```json
{
  "permissions": {
    "allow": [
      "mcp__plugin_jsonschemaapp-mcp_jsonschemaapp__check_page_schema",
      "mcp__plugin_jsonschemaapp-mcp_jsonschemaapp__scan_site",
      "mcp__plugin_jsonschemaapp-mcp_jsonschemaapp__get_scan_status",
      "mcp__plugin_jsonschemaapp-mcp_jsonschemaapp__get_scan_result",
      "mcp__plugin_jsonschemaapp-mcp_jsonschemaapp__check_llms_txt",
      "mcp__plugin_jsonschemaapp-mcp_jsonschemaapp__get_report"
    ]
  }
}
```

## Usage

```
/jsonschemaapp-mcp:report                       # current state of your store
/jsonschemaapp-mcp:scan-site 200                # scan up to 200 pages, then summarize
/jsonschemaapp-mcp:check-page https://site/x     # check one page's structured data
/jsonschemaapp-mcp:check-llms example.com        # llms.txt + AI-crawler access
/jsonschemaapp-mcp:ai-search-audit               # full readiness audit
```

Or just ask in natural language (e.g. "audit my store's structured data") and the
`schema-auditor` subagent will drive the tools for you.

## Skills (model-invoked)

Unlike the slash commands (which you trigger explicitly), the bundled **skills** load
automatically when your request matches their description. No command needed:

| Skill | Activates when you… |
|-------|---------------------|
| `structured-data-audit` | ask to audit/check/improve JSON-LD or Schema.org on your site or a page. |
| `schema-rich-results` | ask which schema types are worth it, what's required, or why FAQPage/HowTo stopped showing rich results. |
| `ai-search-optimization` | ask about AI search visibility, GEO, `llms.txt`, or whether AI crawlers can reach your site. |
| `draft-llms-txt` | ask to write/generate an `llms.txt` or `llms-full.txt`. Drafts a valid file from scan data (the server only *checks* llms.txt). |
| `ai-crawler-access` | ask to unblock GPTBot/ClaudeBot/PerplexityBot etc. Gives copy-paste `robots.txt` snippets for any platform (not just Webflow). |
| `audit-report-format` | reference used whenever results are reported. Defines the one-line-verdict + P1/P2/P3 + tool-citation shape so every audit reads the same. |

They carry the same workflow and rules as the commands/subagent (including the
FAQPage/HowTo rich-result rule) so behavior stays consistent however you invoke it.

## Consistent, grounded audits

So every audit reads the same way and stays efficient, the commands, subagent, and
skills share three conventions (all client-side prompt guidance, no server change):

- **Standard report format.** Every answer leads with a one-line verdict, then findings
  grouped **P1 (blocking)** → **P2 (high value)** → **P3 (incremental)**, each citing the
  tool that produced it. Defined once in the `audit-report-format` skill. Findings must
  trace to real tool output, with no invented scores or errors.
- **Poll backoff for scans.** After `scan_site`, `get_scan_status` is polled with a
  backoff (first poll ~5s, then 5s → 10s → 20s → 30s, ~30s thereafter) instead of a tight
  loop.
- **Pagination discipline.** `get_scan_result` is read with `only_issues: true` and
  `limit: 50`, paging via `offset`, so large scans don't flood context; the full
  inventory (`only_issues: false`) is pulled only when actually needed.

## Note on FAQPage / HowTo

FAQPage and HowTo markup no longer produce Google rich results. The tools report them
at the `ai_readability` level (useful for AI assistants). The commands and the subagent
are instructed never to recommend them as Google rich-result wins.
