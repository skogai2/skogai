---
name: claude-tool-allowlist
description: "clean /skogai claude env: tools are an allowlist (start from none, add), verified by parsing the active tool list"
metadata:
  node_type: memory
  type: project
  stale_after: 2027-01-31
  originSessionId: 4628ea96-f54a-4f09-aa92-36dc1dfb1fec
  modified: 2026-10-31T00:36:12.677Z
---

skogix wants the clean claude env in /skogai (`bin/claude`, `CLAUDE_CONFIG_DIR=/skogai/claude`) to start with no tools and add the wanted ones, and to verify that by parsing which tools are actually active. Raised 2026-10-31 as "not needed now".

**Why:** a new Claude Code version shouldn't silently add tools to a reproducible environment.

**How to apply:**
- Permission rules can't express "deny all, then allow": evaluation order is deny → ask → allow and the first match wins (permissions.md), so `--disallowedTools "*"` beats any allow.
- Allowlist per surface instead: `--tools "A,B"` for built-ins (`""` = none), `--strict-mcp-config` (+ `--mcp-config`) for MCP, `enabledPlugins` / `--disable-slash-commands` for plugins and skills.
- Test: `claude -p --output-format stream-json --verbose` emits a `system`/`init` message first that lists tools, MCP servers, slash commands and plugins. Diff that against the expected set.

Related: [[swap-internals-keep-interface]], [[read-vendored-docs-first]]
