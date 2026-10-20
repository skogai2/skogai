#!/usr/bin/env bash
set -euo pipefail

# mise: dev-tool version manager (assumed standard everywhere)
curl https://mise.run | sh
export PATH="$HOME/.local/bin:$PATH"
eval "$(mise activate bash)"

mise trust
mise install
mise activate

# SkogAI tools
uv tool install "git+https://github.com/skogai/cli.git" --force --upgrade
uv tool install "git+https://github.com/skogai/gita.git" --force --upgrade
