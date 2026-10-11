# mise: an ELI5 for programmers

Basic research on what mise does and how. Sources: the help text of the
locally installed `mise 2026.10.6` and the docs at <https://mise.jdx.dev>,
read on 2026-10-11. Things marked *experimental* need
`mise settings experimental=true` and may change.

## The one-paragraph version

mise is one binary that reads one file (`mise.toml`) and does three classic
jobs: it **installs tools** (replaces nvm, pyenv, asdf), it **sets
environment variables** (replaces direnv, dotenv), and it **runs tasks**
(replaces make, just, npm scripts). Newer versions add a fourth job:
**setting up a whole machine** (`mise bootstrap`: OS packages, dotfiles,
services, login shell), which overlaps with chezmoi, Ansible and a Brewfile.

```toml
# mise.toml
[tools]
node = "24"

[env]
NODE_ENV = "development"

[tasks.test]
run = "npm test"
```

## The mental model

| Idea | What it means |
|---|---|
| Config is layered | Global config is the base, and each `mise.toml` closer to the current directory overrides it. |
| Activation | A shell hook recomputes `PATH` and env vars at every prompt, so tools and vars change as you `cd`. |
| No activation needed | `mise exec -- <cmd>` and `mise run <task>` load the config themselves. Scripts and CI use these. |
| Trust | A project `mise.toml` from someone else does nothing until you run `mise trust`. The global config needs no trust. |
| Nothing is automatic on a machine | `[bootstrap]` sections only apply when you run `mise bootstrap`. |

### Config files and precedence

Lowest to highest:

1. System config (`/etc/mise/`), then global config (`~/.config/mise/config.toml`)
2. `mise.toml` in parent directories
3. `mise.toml` in the project
4. `mise.local.toml` (meant to be gitignored)
5. `mise.<env>.toml` and `mise.<env>.local.toml`, only when `MISE_ENV=<env>` or `-E <env>` is set

`mise config ls` shows which files apply in the current directory. On this
machine that is `/etc/mise/conf.d/omarchy.toml`,
`~/.config/mise/config.toml` and `~/skogai/mise.toml`.

### Three ways to get tools onto PATH

| Way | How | Use it for |
|---|---|---|
| Activate | `mise activate fish \| source` in the shell startup file | Interactive shells. Also applies `[env]`. |
| Shims | Small wrapper executables in `~/.local/share/mise/shims` | Editors, IDEs and anything that doesn't read shell startup files. |
| Exec | `mise exec -- node script.js`, or `mise en` for a subshell | Scripts, CI, one-off runs. |

This machine uses both activation and shims (`mise doctor` reports
`activated: yes` and `shims_on_path: yes`).

## Tools

```toml
[tools]
node = "24"                      # prefix: newest 24.x
python = "latest"
"npm:@termix-ssh/cli" = "latest" # backend:name
"github:jqlang/jq" = "latest"
```

- **Registry**: short names such as `node` or `gh` map to a backend.
  `mise registry` lists them and `mise search` searches them.
- **Backends** are the installers. This install has: `core`, `aqua`, `asdf`,
  `cargo`, `conda`, `dotnet`, `forgejo`, `gem`, `github`, `gitlab`, `go`,
  `npm`, `packslip`, `pypi`, `spinel`, `spm`, `http`, `s3`, `ubi`, `vfox`.
  So one file can pin a Rust crate, an npm CLI, a Python CLI and a GitHub
  release binary side by side.
- **Versions**: exact (`24.11.1`), prefix (`24`) or `latest`.
- **Lockfile**: `mise lock` writes `mise.lock` with resolved versions,
  checksums and download URLs. `mise install --locked` then refuses to
  resolve anything not in the lockfile.
- **Release age**: new releases wait `minimum_release_age` (default `24h`
  for most backends) before mise will pick them, as a supply-chain guard.
- **Other tools' files**: `.tool-versions` is read directly. `.nvmrc`,
  `.python-version` and similar need idiomatic version files turned on.

| Command | Does |
|---|---|
| `mise use node@24` | Install and write it to `mise.toml` (`-g` for global) |
| `mise install` | Install everything the config asks for |
| `mise ls` / `mise outdated` / `mise upgrade` | Inspect and update |
| `mise unuse` / `mise prune` | Remove from config, delete unused versions |

## Environment variables

`[env]` is a table of variables plus a few *directives* under the `_` key.

```toml
[env]
NODE_ENV = "production"
PORT = 8080
OLD_VAR = false                                  # unsets it
LOG_LEVEL = { default = "info" }                 # only if unset or empty
DATABASE_URL = { required = true }               # must come from elsewhere
API_KEY = { required = "Set API_KEY, see README" }

# templates, then shell-style expansion
PROJECT_LIB = "{{config_root}}/lib"
LD_LIBRARY_PATH = "{{env.PROJECT_LIB}}:${LD_LIBRARY_PATH:-}"

# directives
_.path = ["bin", "{{config_root}}/node_modules/.bin"]   # prepended to PATH
_.file = [".env", { path = ".secrets.yaml", redact = true }]
_.source = "scripts/env.sh"                             # bash script, takes its exports
_.python.venv = { path = ".venv", create = true }
```

Things worth knowing:

- **Order matters.** Entries in a file are evaluated top to bottom, so a
  later value can reference an earlier one.
- **`_.file`** picks the format from the extension: `.json`, `.yaml` and
  `.toml` are structured, anything else is dotenv. Missing files are skipped
  silently. Globs such as `.env.*` work.
- **`_.source`** runs a bash script every time the environment is computed.
- **`PATH`** can't be set as a plain key; use `_.path`.
- **`tools = true`** defers a value until after tools are loaded. By default
  `[env]` is resolved first so it can influence installs (for example
  `CFLAGS`). Deferring gives access to things like `{{ tools.node.version }}`:

  ```toml
  NODE_VERSION = { value = "{{ tools.node.version }}", tools = true }
  ```

- **Config environments.** `MISE_ENV=staging` layers `mise.staging.toml` on
  top. `mise set -E staging NODE_ENV=staging` writes to that file.
- **Off switches.** `mise --no-env` or `MISE_NO_ENV=1` skips `[env]`.
  Safe mode (`MISE_SAFE=1`) ignores project `[env]` and never runs `_.source`.

| Command | Does |
|---|---|
| `mise set KEY=value` | Write a variable to `mise.toml` |
| `mise set` | List variables and which file each comes from |
| `mise unset KEY` | Remove one |
| `mise env` | Print the computed environment as shell code |

### `[vars]` are not env vars

`[vars]` holds values for templates (`{{ vars.NAME }}`). They are not
exported to the environment. A var can declare a `prompt`, and
`mise vars prompt` or `mise bootstrap --prompt-vars` will ask for it once and
save the answer in `$MISE_STATE_DIR/vars.toml`, outside every config file.
That makes vars the place for per-machine answers such as an email address or
a hostname-specific choice.

## Secrets

For a worked setup see [who-and-mode.md](who-and-mode.md); for traps see
[gotchas.md](gotchas.md).

There are four approaches. The main difference is *who gets to see the
plaintext*.

| Approach | Status | What is in the repo | Who receives the values |
|---|---|---|---|
| fnox source | experimental, the one the docs recommend | `fnox.toml` with references or encrypted values | Only tasks that list the key |
| SOPS file | stable | Encrypted `.env.json` / `.env.yaml` / `.env.toml` | Everything that loads `[env]` |
| age values | experimental | Encrypted values inline in `mise.toml` | Everything that loads `[env]` |
| Untracked file | n/a | Nothing (`mise.local.toml` or `.env` is gitignored) | Everything that loads `[env]` |

**SOPS** is the simple one: encrypt a file, load it with `_.file`, and mise
decrypts it while loading. It needs an age identity, or the `sops` CLI for
KMS, Vault or PGP.

```toml
[env]
_.file = { path = ".env.json", redact = true }
```

**fnox** is the scoped one. Secrets are fetched from a provider (1Password,
AWS Secrets Manager, AWS KMS and others) and handed only to the tasks that
ask for them. The shell, hooks, task dependencies and `mise env` get nothing.

```toml
[secrets.fnox]

[tasks.deploy]
secrets = ["DEPLOY_KEY", "DATABASE_URL"]
run = "./deploy.sh"
```

`mise secrets ls` lists the secret names without the values. It needs fnox
1.39.0 or newer (`mise use fnox`).

### Redaction is masking, not encryption

`redact = true` replaces a value with `[redacted]` in output that mise
processes. The program still receives the real value.

```toml
redactions = ["SECRET_*", "*_TOKEN", "PASSWORD"]   # by name pattern

[env]
SECRET = { value = "my_secret", redact = true }
TEST_TOKEN = { value = "not-sensitive", redact = false }   # exempt
```

| Masked | Not masked |
|---|---|
| `mise run` task output and the command lines it prints | Tasks with `raw = true` or `interactive = true`, or `--raw` |
| mise's own log messages | `mise exec` output |
| The value column of `mise set` | `mise env`, which prints real values by design |

`mise env --redacted` prints *only* the sensitive variables, with their real
values. It exists to pipe secrets into another program on purpose, for
example to register CI masks.

## Tasks

A task is either a TOML table or an executable file. Both use the same runner.

```toml
[tasks.build]
description = "Build the CLI"
run = "cargo build"
sources = ["Cargo.toml", "src/**/*.rs"]   # skip the task if these are unchanged
outputs = ["target/debug/mycli"]

[tasks.ci]
depends = ["lint", "test"]                # may run in parallel
run = [
  "cargo fmt --check",                    # steps run in order
  { tasks = ["test", "lint"] },           # a parallel group
]

[tasks.deploy]
confirm = "Deploy?"
env = { TARGET = "prod" }
tools = { node = "24" }                   # only for this task
usage = 'arg "<version>"'                 # typed args, --help, completions
run = "./deploy.sh {{ usage.version }}"
```

File tasks live in `mise-tasks/` and put their metadata in comments:

```bash
#!/usr/bin/env bash
#MISE description="Cut a new release"
#MISE depends=["build"]
#USAGE arg "<version>" help="Version to release"
```

Key properties:

| Property | Meaning |
|---|---|
| `run` | A command, or a list of steps that stops at the first failure |
| `depends` | Must finish first. A shared dependency runs once. List order is not a sequence. |
| `depends_post` | Runs afterwards, even if the task failed |
| `wait_for` | Wait for a task only if it is already scheduled; don't add it |
| `sources` / `outputs` | Freshness check and artifact cache |
| `env`, `tools`, `dir`, `shell`, `timeout` | Per-task environment, tools, working directory, interpreter, limit |
| `secrets` | Keys this task alone receives (*experimental*, fnox) |
| `usage` | Argument spec, exposed as `$usage_<name>` and `{{ usage.name }}` |
| `confirm`, `hide`, `alias` | Prompt, hide from listings, extra names |
| `raw`, `interactive` | Attach straight to the terminal (turns off redaction) |
| `file` | Run a script from a path, an HTTP(S) URL or a `git::` URL |
| `extends` | Inherit from a `[task_templates.<name>]` entry |

| Command | Does |
|---|---|
| `mise run <task>` or `mise <task>` | Run it. Missing tools are installed first. |
| `mise tasks ls` / `mise tasks info <task>` | List, and show where one is defined |
| `mise watch <task>` | Rerun when `sources` change (needs watchexec) |
| `mise generate git-pre-commit` / `github-action` / `task-docs` | Generate a git hook, a CI workflow or Markdown docs from tasks |

Related, both *experimental*:

- **`mise deps`** installs project dependencies (`node_modules`, a uv
  environment) only when their inputs changed, and can do so automatically
  before `mise run` and `mise exec`.
- **`mise daemons`** keeps long-running processes (a dev server, `postgres`,
  `redis`) alive with readiness checks, using pitchfork.

## From a bare OS to a working machine

`mise bootstrap` reads the same config and applies everything a machine
needs. It is declarative and idempotent: parts that already match are left
alone, so it is safe to rerun.

### The flow on a fresh install

```sh
curl -fsSL https://mise.run | sh                      # installs ~/.local/bin/mise
~/.local/bin/mise bootstrap --adopt OWNER/REPO --dry-run
~/.local/bin/mise bootstrap --adopt OWNER/REPO
```

- `--adopt <url|OWNER/REPO>` clones a repo of global mise config into
  `~/.config/mise` (or restores a dotfile-history repo) and applies it.
- `--from <url>` clones a self-contained bootstrap project (a repo with a
  `mise.toml`) into a separate checkout and applies that.
- `mise generate install-script` produces a script that downloads a pinned
  mise version, for when "latest" isn't acceptable.

### What it can declare

| Section | Manages |
|---|---|
| `[bootstrap.packages]`, `[bootstrap.plugins]` | OS packages: apt, dnf, pacman, AUR helpers, apk, zypper, nix, Homebrew, Flatpak, mas, WinGet, scoop |
| `[bootstrap.users]`, `[bootstrap.groups]` | Linux users and groups |
| `[bootstrap.files]`, `[bootstrap.directories]` | System files with content, owner and permissions |
| `[bootstrap.secrets]` | Secret inputs that file and dotfile templates can read |
| `[bootstrap.services]` | User services, and existing Linux system services |
| `[bootstrap.linux.firewall]` | Host firewall policy and rules |
| `[bootstrap.linux.systemd.units]` | systemd user units |
| `[bootstrap.compose]` | Docker Compose projects |
| `[bootstrap.repos]` | Git repos to clone |
| `[dotfiles]`, `[dotfile_groups]` | Dotfiles (see below) |
| `[bootstrap.mise_shell_activate]`, `[bootstrap.user]` | Shell activation lines, login shell |
| `[bootstrap.macos.*]` | `defaults write` preferences, LaunchAgents |
| `[tools]` | The same tools `mise install` installs |
| `[bootstrap.hooks]`, `[tasks.bootstrap]` | Escape hatches for everything else |

```toml
[bootstrap.packages]
"apt:build-essential" = "latest"            # "latest" = any installed version is fine
"apt:curl" = "8.5.0-2ubuntu10"              # pinned, in the manager's own format
"brew-cask:1password" = { os = "macos" }
"brew-cask:slack" = { env = "work" }        # only when MISE_ENV=work
"pacman:libreoffice-fresh" = { state = "absent" }

[bootstrap.mise_shell_activate]
fish = true

[bootstrap.hooks]
final = "mise exec -- gh auth status"

[tasks.bootstrap]
run = "node --version"
```

### Order of a run

1. Resolve secret inputs and render templates. A missing value stops the run before anything changes.
2. Accounts, package plugins, then OS packages
3. System files, services, firewall, Compose
4. Repos, then dotfiles
5. Shell activation, macOS defaults, systemd units, login shell
6. Tools
7. The `bootstrap` task, then the `final` hook

`--only <part>` and `--skip <part>` select parts by those names.

### Inspecting before applying

| Command | Shows |
|---|---|
| `mise bootstrap --dry-run` | What a run would do. Hooks and the task are printed, not run. |
| `mise bootstrap status` | The state of every part. `--missing` sets the exit code for CI. |
| `mise bootstrap plan` | Resource-level changes for packages, files, services, firewall, Compose |
| `mise bootstrap unapply` | Removes what a config environment's bootstrap sections created |

### Dotfiles

`mise dotfiles` (alias `mise dot`) has two modes that can be mixed:

- **Deploy**: a `[dotfiles]` entry puts a file in place from a source, by
  `symlink`, `copy` or `template`, or from inline `content`. `mise dot apply`,
  `diff`, `status` and `unapply` work on these.
- **Track**: `mise dot track <path>` leaves the file where it is and saves
  checkpoints of it to a local Git history. `history`, `rollback` and `undo`
  browse and restore; `origin`, `sync` and `pull` share it between machines.
  A tracked file can have per-OS, per-environment or per-machine variants.

### Other machines

- `mise bootstrap remote` applies a config to hosts over SSH
  (`[bootstrap.remote]`).
- `mise ssh --github-relay-read-only` opens an SSH session where the remote
  host can clone and download from GitHub repos you allow, using this
  machine's credentials. The token is never copied to the host.
- `mise oci` builds a container image from a project's tools, one layer per
  tool version (*experimental*).
- `mise generate devcontainer` writes a devcontainer config that installs
  mise and the project's tools.

### Gotchas

- **Not a transaction.** If step 6 fails, steps 1 to 5 stay applied. Fix and rerun.
- **Hooks and the `bootstrap` task run every time**, so they must be safe to repeat.
- **`--only` doesn't pull in dependencies.** A file owned by a new user needs both `accounts` and `files`.
- **`--dry-run` still renders templates**, so an `exec()` inside one runs.
- **sudo**: apt, dnf, pacman, apk and zypper run through `sudo`, and each
  command is logged first. AUR helpers refuse to run as root and call sudo
  themselves. `system_packages.sudo = false` forbids elevation.
- **`"latest"` never upgrades** an installed package. Use
  `mise bootstrap packages upgrade` for that.
- **Removal** (`state = "absent"`) only works for pacman, scoop and zypper.

## What it replaces

| Job | Usual tool | mise |
|---|---|---|
| Language versions | nvm, pyenv, rbenv, asdf | `[tools]` |
| CLI tools from GitHub, npm, cargo, pipx | each ecosystem's installer | `[tools]` with a backend prefix |
| Per-directory env vars | direnv, dotenv | `[env]` |
| Secrets in env | sops plus wrapper scripts | `_.file` with SOPS, or fnox |
| Task runner | make, just, npm scripts | `[tasks]`, `mise-tasks/` |
| File watcher | watchexec, entr | `mise watch` |
| Dotfiles | chezmoi, stow, yadm | `[dotfiles]`, `mise dot` |
| Machine setup | Ansible, Brewfile, shell scripts | `mise bootstrap` |
| Dev services | docker-compose, overmind | `[daemons]` (*experimental*) |

## Not verified here

- The exact syntax for inline age-encrypted values. The secrets page names
  the feature but shows no example.
- A worked `aur:` or `flatpak:` package entry. The managers are listed, and
  the `"manager:package" = "version"` form is documented, but the docs page
  read here only showed a `pacman:` entry in its removal example.
- Entry syntax for `[bootstrap.repos]`, `[bootstrap.user]`,
  `[bootstrap.services]` and `[dotfiles]`. Their subpages weren't read.
- Nothing here was run against this machine beyond read-only commands
  (`--help`, `mise doctor`, `mise config ls`).
