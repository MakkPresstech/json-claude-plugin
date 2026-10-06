#!/usr/bin/env bash
# SessionStart guard for the JSONSchemaApp MCP plugin.
#
# This is a non-blocking reminder only: it never fails and never mutates state.
# It cannot see Claude's live MCP connection status, so it just surfaces the
# one setup step people forget — completing OAuth — before a tool call fails
# with a cryptic 401. If the server is already connected, ignore the notice.
#
# Exit 0 always so a missing or odd environment can never break a session.

cat <<'NOTE'
JSONSchemaApp MCP plugin loaded.

Before using the structured-data tools (check_page_schema, scan_site,
get_scan_status, get_scan_result, check_llms_txt, get_report):

  1. Run /mcp and confirm the `jsonschemaapp` server shows as connected.
  2. If it is not connected, complete the OAuth prompt (or set a jsa_live_ API
     key per the plugin README). Tools will return 401 until this is done.

Quick check once connected: /jsonschemaapp-mcp:report
NOTE

exit 0
