#!/usr/bin/env bash
# SessionStart guard for the JSON Schema App MCP plugin.
#
# This is a non-blocking reminder only: it never fails and never mutates state.
# It cannot see Claude's live MCP connection status, so it just surfaces the
# one setup step people forget (completing OAuth) before a tool call fails
# with a cryptic 401. If the server is already connected, ignore the notice.
#
# Everything below is a shell builtin. The script reads no other file, runs no
# other program, and installs nothing, so it is trivial to audit and to follow
# statically. Exit 0 always, so a missing or odd environment can never break a
# session.

printf '%s\n' \
  'JSON Schema App MCP plugin loaded.' \
  '' \
  'Before using the structured-data tools (check_page_schema, scan_site,' \
  'get_scan_status, get_scan_result, check_llms_txt, get_report):' \
  '' \
  '  1. Run /mcp and confirm the `jsonschemaapp` server shows as connected.' \
  '  2. If it is not connected, complete the OAuth prompt. Tools will return' \
  '     401 until you do. To use a jsa_live_ API key instead of OAuth, add your' \
  '     own user-scope MCP server as the plugin README describes.' \
  '' \
  'Quick check once connected: /jsonschemaapp-mcp:report'

exit 0
