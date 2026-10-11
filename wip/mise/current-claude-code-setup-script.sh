#!/usr/bin/env bash
# Setup script for Claude Code cloud environments (Environment settings ->
# Setup script). It runs once per container, as root, in a non-interactive
# shell. Nothing it exports or activates reaches the Claude session: each
# Bash tool call starts a fresh shell from the user profile, so anything that
# must persist goes into ~/.bashrc or mise's global config.
set -euo pipefail

export PATH="$HOME/.local/bin:$HOME/.local/share/mise/shims:$PATH"

# mise: dev-tool version manager (assumed standard everywhere)
command -v mise >/dev/null || curl -fsSL https://mise.run | sh

# Global settings, written to ~/.config/mise/config.toml so they persist.
# - trust every config under /home/user (the repo checkouts), so trust does
#   not depend on which directory this script runs in or whether the repo is
#   cloned yet
# - experimental: needed for `[secrets]` / `mise secrets` (see wip/mise/example)
mise settings add trusted_config_paths /home/user
mise settings set experimental true

# Make mise tools visible to the session's shells. Shims rather than
# `mise activate`: activation updates PATH from a prompt hook, which
# non-interactive shells never run. Goes at the top of ~/.bashrc because it
# returns early for non-interactive shells.
shims_line='export PATH="$HOME/.local/share/mise/shims:$HOME/.local/bin:$PATH"'
if ! grep -qxF "$shims_line" ~/.bashrc 2>/dev/null; then
  printf '%s\n%s\n' "$shims_line" "$(cat ~/.bashrc 2>/dev/null)" > ~/.bashrc
fi

# Install tools for any checkout that is already present. If the repo is
# cloned after this script runs, `mise install` in the session does the same.
for cfg in "$PWD/mise.toml" /home/user/*/mise.toml; do
  [ -f "$cfg" ] || continue
  (cd "$(dirname "$cfg")" && mise install) || echo "mise install failed in ${cfg%/*}" >&2
done

# fnox: no key setup needed here. Add FNOX_AGE_KEY as an environment
# variable/secret in the environment settings and fnox reads it directly;
# it overrides FNOX_AGE_KEY_FILE in wip/mise/example.

# SkogAI tools
uv tool install "git+https://github.com/skogai/cli.git" --force --upgrade
uv tool install "git+https://github.com/skogai/gita.git" --force --upgrade
