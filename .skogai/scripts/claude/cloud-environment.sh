###
###
###
# Use the existing checkouts under /workspace. Each cloud task is isolated; do not create Git worktrees unless the user explicitly requests them. Keep tracked source, tests, manifests and lockfiles unchanged during environment setup.
#
# First source /workspace/.cloud-setup/env.sh in every shell. This selects the Go compiler instead of /usr/bin/go (GNU Go), activates pnpm, Cargo, mise, argc, yq, Bats and Claude plugin tools, and sets writable cache/config paths. Use umask 022 when running OKN permission-preservation tests. Read /workspace/.cloud-setup/REPORT.md for scope, validation evidence and diagnosed limitations. Read each checkout's agent instructions before work. All 24 selected checkouts remain in their original /workspace directories.
#
# The prepared workflow is credential-free library, CLI and plugin development. Dependencies and builds are retained in the published filesystem snapshot; live processes are not. No daemon is required for normal work. If dependencies need refreshing, run bash /workspace/.cloud-setup/install.sh. It preserves repository manifests and lockfiles, uses frozen installs where provided, and limits Rust/Go build parallelism to four.
#
# Useful validated checks, from their respective directories:
# - /workspace/adhd: npm test; npm run build; npm run typecheck
# - /workspace/forge: pnpm --filter @cloudflare/forge test; pnpm --filter @cloudflare/forge typecheck
# - /workspace/inbox-mod: .venv/bin/python -m pytest (full suite takes about six minutes). For manual CLI probes set CACTUS_DB to a fresh scratch path and CACTUS_POKE=true; never touch a live inbox or prompt real agents.
# - /workspace/gptme-contrib: .venv/bin/python -m pytest packages/gptme-coordination/tests
# - /workspace/captains-deck: /workspace/gptme-contrib/.venv/bin/python -m pytest tests -q
# - /workspace/open-knowledge-format and /workspace/knowledge-catalog/okf: /workspace/.cloud-setup/venvs/okf/bin/python -m pytest tests -q
# - /workspace/skogtokens: cargo test --locked --workspace (4,955 passed, eight ignored).
# - /workspace/okn: pnpm build:cli; pnpm test:web; ./bin/openknowledge --no-telemetry validate Wiki
# - /workspace/loadout: claude plugin validate .; claude plugin test .
# - /workspace/marketplace: bash scripts/generate-marketplace-json.sh --check
# The full OKF plugin, SkogAI CLI, Knowledge Catalog tool and OKN Go suites have diagnosed failures described in REPORT.md; do not report them as passing or disable their assertions. The shared coordination package is representative of gptme-contrib; optional voice/RAG/social integrations and full Forge SDK generation were not installed or validated.
#
# Optional viewer startup: cd /workspace/okn and run ./bin/openknowledge --no-telemetry view --no-browser --port 8787 /workspace/okn/Wiki. Keep the process in the foreground or a managed shell session. From another shell, request http://127.0.0.1:8787/ and require HTTP 200 and an HTML document. This functional check passed during onboarding. Stop only processes started by this task. Do not publish localhost preview links. If port 8787 is in use, choose another free local port.
#
# Claude Code plugin tests work using the configured CLAUDE_CONFIG_DIR. gptme 0.34.0 is installed but its hardcoded ~/.config/gptme configuration path remains blocked by the read-only home. The legacy ECS checkout targets netcoreapp3.1; .NET SDK 10 is installed, but build fails creating named-mutex state in ~/.dotnet on the read-only home, and the 3.1 runtime is absent. Do not claim these agent or legacy .NET workflows are ready. The cli checkout hardcodes /home/skogix defaults, and the OKF plugin checkout lacks the plugin manifest read by one test: separate code tasks are required. Do not write fake credentials or host configuration to force tests to pass.
#
# GitHub reads work with the injected HTTPS Git proxy; do not request tokens based on CLI login state. No new secrets are required for the validated workflow. Live Google Cloud/LLM operations, Herdr UI and host user/systemd/dotfile bootstrapping are optional and require separate compatible runtime configuration and authentication. Do not start autonomous agents, install host dotfiles, or create Unix users as part of startup. Saving configuration is separate from publication; fresh-task snapshot restoration has not yet been independently validated.
###
###
###

#!/usr/bin/env bash
set -euo pipefail
mkdir -p /workspace/.cloud-setup/bin
cat > /workspace/.cloud-setup/env.sh <<'CLOUD_SETUP_FILE'
export CLOUD_SETUP_ROOT=/workspace/.cloud-setup
export PATH="$CLOUD_SETUP_ROOT/bin:$CLOUD_SETUP_ROOT/tools/node/node_modules/.bin:$CLOUD_SETUP_ROOT/tools/go/bin:$CLOUD_SETUP_ROOT/tools/cargo/bin:$CLOUD_SETUP_ROOT/tools/mise/bin:$CLOUD_SETUP_ROOT/tools/bats/bin:$CLOUD_SETUP_ROOT/tools/dotnet:$PATH"
export UV_CACHE_DIR="$CLOUD_SETUP_ROOT/cache/uv"
export UV_TOOL_DIR="$CLOUD_SETUP_ROOT/tools/uv-tools"
export UV_TOOL_BIN_DIR="$CLOUD_SETUP_ROOT/bin"
export CARGO_HOME="$CLOUD_SETUP_ROOT/tools/cargo"
export RUSTUP_HOME="$CLOUD_SETUP_ROOT/tools/rustup"
export CARGO_TARGET_DIR="$CLOUD_SETUP_ROOT/cache/rtk-target"
export CARGO_BUILD_JOBS=4
export GOPATH="$CLOUD_SETUP_ROOT/cache/go"
export GOCACHE="$CLOUD_SETUP_ROOT/cache/go-build"
export GOMAXPROCS=4
export TMPDIR="$CLOUD_SETUP_ROOT/tmp"
export XDG_CACHE_HOME="$CLOUD_SETUP_ROOT/cache"
export XDG_CONFIG_HOME="$CLOUD_SETUP_ROOT/config"
export XDG_DATA_HOME="$CLOUD_SETUP_ROOT/data"
export XDG_STATE_HOME="$CLOUD_SETUP_ROOT/state"
export MISE_DATA_DIR="$CLOUD_SETUP_ROOT/mise/data"
export MISE_STATE_DIR="$CLOUD_SETUP_ROOT/mise/state"
export MISE_CACHE_DIR="$CLOUD_SETUP_ROOT/cache/mise"
export MISE_CONFIG_DIR="$CLOUD_SETUP_ROOT/mise/config"
export MISE_OFFLINE=true
export CLAUDE_CONFIG_DIR="$CLOUD_SETUP_ROOT/claude-config"
export DOTNET_ROOT="$CLOUD_SETUP_ROOT/tools/dotnet"
export DOTNET_CLI_HOME="$CLOUD_SETUP_ROOT/dotnet-home"
export NUGET_PACKAGES="$CLOUD_SETUP_ROOT/cache/nuget"
export DOTNET_CLI_TELEMETRY_OPTOUT=1

CLOUD_SETUP_FILE
cat > /workspace/.cloud-setup/bin/uv <<'CLOUD_SETUP_FILE'
#!/bin/sh
export UV_CACHE_DIR=/workspace/.cloud-setup/cache/uv
exec /opt/codex/runtimes/codex-primary-runtime/dependencies/python/bin/uv "$@"

CLOUD_SETUP_FILE
cat > /workspace/.cloud-setup/install.sh <<'CLOUD_SETUP_FILE'
#!/usr/bin/env bash
set -euo pipefail
root=/workspace/.cloud-setup
mkdir -p "$root"/{bin,cache,tools,logs,tmp,config,data,state}
source "$root/env.sh"
node -e 'if(Number(process.versions.node.split(".")[0])<22)process.exit(1)'
command -v uv >/dev/null
download() { curl --fail --silent --show-error --location "$1" --output "$2"; }
verify() { printf '%s  %s\n' "$1" "$2" | sha256sum --check --status; }
if [ ! -x "$root/tools/dotnet/dotnet" ]; then
  download https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.402/dotnet-sdk-10.0.402-linux-x64.tar.gz "$root/cache/dotnet.tar.gz"
  printf '%s  %s\n' 1904a98dda2db34ba78ba3c4fb1b224455329af91c341d83547843c1839e112b04ae699ee92fa2449a8f62249196a938723078c0c60b9f65c88539d5687729c2 "$root/cache/dotnet.tar.gz" | sha512sum --check --status
  mkdir -p "$root/tools/dotnet"
  tar -xzf "$root/cache/dotnet.tar.gz" -C "$root/tools/dotnet"
fi
if [ ! -x "$root/tools/go/bin/go" ]; then
  download https://go.dev/dl/go1.26.10.linux-amd64.tar.gz "$root/cache/go.tar.gz"
  verify ccfe7ae822d2c2f41f4fe7c956199967a4dac22d0ee0d2b2bfdb440aab3b20c5 "$root/cache/go.tar.gz"
  tar -xzf "$root/cache/go.tar.gz" -C "$root/tools"
fi
if [ ! -x "$root/tools/cargo/bin/cargo" ]; then
  download https://sh.rustup.rs "$root/cache/rustup-init.sh"
  sh "$root/cache/rustup-init.sh" -y --no-modify-path --profile minimal --default-toolchain 1.91.0
fi
if [ ! -x "$root/tools/mise/bin/mise" ]; then
  download https://github.com/jdx/mise/releases/download/v2026.10.18/mise-v2026.10.18-linux-x64.tar.xz "$root/cache/mise.tar.xz"
  download https://github.com/jdx/mise/releases/download/v2026.10.18/SHASUMS256.txt "$root/cache/mise-sha256.txt"
  mise_digest=$(awk '$2=="./mise-v2026.10.18-linux-x64.tar.xz" {print $1}' "$root/cache/mise-sha256.txt")
  test -n "$mise_digest"
  verify "$mise_digest" "$root/cache/mise.tar.xz"
  tar -xJf "$root/cache/mise.tar.xz" -C "$root/tools"
fi
if [ ! -x "$root/bin/argc" ]; then
  download https://github.com/sigoden/argc/releases/download/v1.24.0/argc-v1.24.0-x86_64-unknown-linux-musl.tar.gz "$root/cache/argc.tar.gz"
  verify 92e2c30ef078e0a66855b5bdd389cefa7ac6ef4c1fe0b177f3f0bf639891aa72 "$root/cache/argc.tar.gz"
  tar -xzf "$root/cache/argc.tar.gz" -C "$root/bin"
fi
if [ ! -x "$root/bin/yq" ]; then
  download https://github.com/mikefarah/yq/releases/download/v4.49.2/yq_linux_amd64 "$root/cache/yq"
  download https://github.com/mikefarah/yq/releases/expanded_assets/v4.49.2 "$root/yq-assets.html"
  python - <<'PY'
from pathlib import Path
import re, hashlib, shutil
r=Path('/workspace/.cloud-setup')
m=re.search(r'aria-label="Copy to clipboard digest for yq_linux_amd64"[^>]*value="sha256:([a-f0-9]{64})"',(r/'yq-assets.html').read_text())
assert m and hashlib.sha256((r/'cache/yq').read_bytes()).hexdigest()==m[1]
shutil.copyfile(r/'cache/yq',r/'bin/yq');(r/'bin/yq').chmod(0o755)
PY
fi
if [ ! -x "$root/tools/bats/bin/bats" ]; then
  git clone --depth 1 --branch v1.12.0 https://github.com/bats-core/bats-core.git "$root/tools/bats"
fi
npm install --prefix "$root/tools/node" pnpm@10.27.0 @anthropic-ai/claude-code@2.1.310 --cache "$root/cache/npm" --no-audit --no-fund
(cd /workspace/adhd && npm ci --cache "$root/cache/npm" --no-audit --no-fund && npm run build)
for project in forge okn; do
  (cd "/workspace/$project" && pnpm install --frozen-lockfile --store-dir "$root/cache/pnpm")
done
(cd /workspace/inbox-mod && uv sync --frozen --group dev)
(cd /workspace/gptme-contrib && uv sync --frozen --package gptme-coordination --extra test)
if [ ! -x "$root/venvs/okf/bin/python" ]; then uv venv "$root/venvs/okf"; fi
uv pip install --python "$root/venvs/okf/bin/python" -e '/workspace/open-knowledge-format[dev]'
uv tool install 'gptme[server,acp]==0.34.0'
# A single lockfile URL points at an inaccessible staging registry. Change only
# the transport URL in an external copy; preserve its version and integrity.
python - <<'PY'
from pathlib import Path
import json
s=Path('/workspace/knowledge-catalog/toolbox/mdcode');d=Path('/workspace/.cloud-setup/staging/mdcode');d.mkdir(parents=True,exist_ok=True)
r=json.loads((s/'package-lock.json').read_text());p=r['packages']['node_modules/typescript']
if p.get('resolved','').startswith('https://us-npm.pkg.dev/artifact-foundry-prod/ah-3p-staging-npm/'):
    p['resolved']='https://registry.npmjs.org/typescript/-/typescript-'+p['version']+'.tgz'
(d/'package.json').write_bytes((s/'package.json').read_bytes());(d/'package-lock.json').write_text(json.dumps(r))
PY
npm ci --prefix "$root/staging/mdcode" --cache "$root/cache/npm" --no-audit --no-fund
python - <<'PY'
import shutil
from pathlib import Path
src=Path('/workspace/.cloud-setup/staging/mdcode/node_modules')
dst=Path('/workspace/knowledge-catalog/toolbox/mdcode/node_modules')
for p in src.rglob('*'):
    target=dst/p.relative_to(src)
    if p.is_symlink() and target.is_symlink(): target.unlink()
shutil.copytree(src,dst,dirs_exist_ok=True,symlinks=True)
PY
(cd /workspace/okn && pnpm build:cli)
(cd /workspace/skogtokens && cargo build --locked -p rtk)
ln -sfn /workspace/okn/bin/openknowledge "$root/bin/okn"
ln -sfn /workspace/inbox-mod/.venv/bin/cactus "$root/bin/cactus"
ln -sfn /workspace/gptme-contrib/.venv/bin/gptme-coordination "$root/bin/gptme-coordination"
ln -sfn "$root/cache/rtk-target/debug/rtk" "$root/bin/rtk"
printf 'Dependencies prepared. Source /workspace/.cloud-setup/env.sh before development.\n'

CLOUD_SETUP_FILE
chmod +x /workspace/.cloud-setup/bin/uv
bash /workspace/.cloud-setup/install.sh
