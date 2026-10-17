# omarchy vs skogix: the real delta, and how `mise dot` holds it

Status: research, 2026-10-14. Read-only survey of this workstation
(omarchy 4.0.4, mise 2026.10.9). `mise dot status` reports nothing configured
and no checkpoints, so this is a clean slate.

Marks: **[v]** verified on this machine, **[d]** from the mise docs in
`tmp/mise/docs/dotfiles*` only, **[i]** inferred, not tested.

For the general `mise dot` modes see [overview.md](overview.md#dotfiles).

## Where omarchy's seed actually comes from

| Thing | What it is | Mark |
|---|---|---|
| `/etc/skel/.config/**`, `.bashrc`, `.local/**` | The real seed. `useradd -m` copies it. Owned by `omarchy-settings` (+ `omarchy-nvim` for `nvim`). | [v] |
| `/usr/share/omarchy/config` | Same tree as skel minus `nvim` and `omarchy/branding`. Source for `omarchy-refresh-config <path>`. | [v] |
| `omarchy-refresh-config <path>` | `cp -f` shipped file over yours, keeps a `.bak.<epoch>`. Wrapped by `omarchy-refresh-{hyprland,tmux,herdr,...}`. | [v] |
| `omarchy-reinstall-configs` | `cp -af /etc/skel/. ~/` — resets every seeded file at once. | [v] |
| `migrations/*.sh` (106, all applied here) | 47 of them edit `$HOME` files in place: `sed -i` (12, only 3 with `--follow-symlinks`), `awk > tmp && mv` (14), `ln -sfn` (9), `omarchy-refresh-config` (2). Targets: `omarchy/shell.json`, `hypr/*.lua`, `tmux.conf`, `kitty`, `foot`, `ghostty`, `alacritty`, `*-flags.conf`, `nvim` theme link, `systemd/user` wants. | [v] |
| `etc-overrides/` | Root-side only (cups, nsswitch, os-release, plymouth, faillock, `dot.bashrc` = skel `.bashrc`), installed by `install/post-install/pacman.sh`. Doesn't touch `$HOME`. | [v] |
| `omarchy-hook-install` | Writes `~/.config/omarchy/hooks/post-update.d/*.hook` (voxtype, agent, fingerprint invitations). Omarchy-authored, not skogix's. | [v] |

So yes: omarchy rewrites `~/.config` on upgrade, surgically, via migrations.
Hypr is designed for layering: `hyprland.lua` loads
`/usr/share/omarchy/default/hypr/*` then `require`s the user files, so the user
hypr files are already "overrides only" — but they ship as templates full of
commented-out examples, and skogix's delta is partly *uncommenting* them.

## 1. Omarchy-shipped config vs `~/.config`

No omarchy file in `~/.config` is a symlink or include of `/usr/share`; all are
plain copies. [v]

| Entry | State | Delta gist |
|---|---|---|
| alacritty, foot, ghostty, kitty, imv, lazygit, obsidian, starship.toml, wireplumber, xournalpp, hyprland-preview-share-picker | identical | — |
| hypr/hyprland.lua, autostart.lua, hyprsunset.conf, xdph.conf | identical | — |
| hypr/bindings.lua | modified, +130 | i3 port: hjkl focus/move, `SUPER+D` apps, `SUPER+T` grouping, relocated defaults. Appended block. |
| hypr/input.lua | modified, ~20 | Uncommented `hl.config` block: `se` / `us_dvorak`, `caps:swapescape`, repeat, numlock. |
| hypr/looknfeel.lua | modified, ~25 | Uncommented layout ratio `16,9` + appended `movefocus_cycles_groupfirst`. |
| hypr/monitors.lua | modified, 4 | `DP-2 1920x1080@144`, scale 1.25, GDK 1. **Machine-specific.** |
| tmux/tmux.conf | modified, ~22 | Split on `-`/`|`, `M-hjkl` focus, `M-HJKL` resize, `h`/`l` window nav. In-place replacements. |
| herdr/config.toml | modified, ~49 | Same hjkl remap as tmux, `onboarding=false`, `auto_switch=false`. Plus runtime state (sockets, logs, sessions, plugins). |
| omarchy/shell.json | modified, ~50 | Bar layout reshuffled (indicators right, active-window center, custom clock format); `version`/`idle` keys dropped. `.bak` left by a migration/refresh. |
| git/config | modified, 10 | `[user]` (contains email), `templateDir`, gh credential helper hard-coding `mise/installs/gh/2.102.0/...`. Plus `ignore` and `hooks` (symlink, see surprises). |
| chromium-flags.conf | modified, 1 | One added flag (OAuth client id). |
| opencode/opencode.json | modified, 1 | `theme` removed. Rest of dir is skogix's (plugins, node_modules, tui.json). |
| btop/btop.conf | modified, ~20 | Mostly btop rewriting itself for v1.4.7; one real choice (`show_disks=false`). `themes/current.theme` is omarchy's symlink. |
| autostart | +2 | `bitwarden.desktop`, `claude-desktop.desktop` added by apps. |
| fcitx5 | +state | `cached_layouts`, `profile`, `notifications.conf`. |
| chromium | state | Browser profile; `Default/Preferences` differs. |
| omarchy/ | mostly omarchy | shell.json (above), `themed/spotifast.json.tpl` + `hooks/theme-set.d/{omazed,spotifast-theme}` are skogix's; other hooks, `defaults/agent`, `branding` are omarchy-written. |
| nvim (from skel) | modified | `lua/config/keymaps.lua` and new `lua/plugins/herdr-nvim.lua` are skogix's; `lazy-lock.json`, `lazyvim.json`, `all-themes.lua` are lazy/omarchy churn. |
| `~/.bashrc` / `.bash_profile` | modified | +~20 / +2 lines appended: vi mode, atuin, `wt` init, `~/.local/bin/env`, argc. Pure append. |

**Real authored delta on omarchy files: ~10 files, ~350 changed lines**, of
which ~200 are comments in `bindings.lua`/`looknfeel.lua`. The rest of the
"differences" are app state or omarchy's own writes.

## 2. `~/.config` entries omarchy doesn't ship

| Class | Entries | Notes |
|---|---|---|
| skogix-authored config | `fish` (config.fish, conf.d, functions), `atuin`, `worktrunk/config.toml`, `voxtype`, `zed`, `gita`, `spotifast/settings.json`+themes, `gptme/config.toml`, `systemd/user/*.service|timer` (collie, gptme-agent-*, gptme-server, voxtype), `mise/config.toml`, `skogai` (own git repo), `opencode` plugins | Candidates for mise. `skogai` is already a repo: leave it. |
| secret-bearing | `anthropic/credentials`, `fnox/age.txt` + `identities/`, `gh/hosts.yml`, `gptme/oauth`, `gptme/server.env`, `Bitwarden CLI/data.json`, `tailscale/ssh_known_hosts` (not secret, but host-specific) | Contents not inspected. |
| omarchy/OS-written state | `mimeapps.list`, `xdg-terminals.list` (omarchy-default-terminal/browser), `user-dirs.*`, `systemd/user/*.wants` links to `/usr/lib` omarchy units, `menus`, `dconf`, `gtk-3.0`, `pulse` | Leave to omarchy. |
| app state / caches | `Claude` 847M, `discordcanary` 627M, `Codex` 158M, `Bitwarden` 4M, `chromium`, `google-chrome*`, `microsoft-edge*`, `BraveSoftware`, `opera`, `vivaldi`, `termix`, `containers`, `go/telemetry`, `openknowledge`, `pangolin`, `hunk`, `uv`, `worktrunk/approvals.toml`, `ibus`, `fcitx`, `lazydocker`, `mpv`, `nautilus`, `yay` | Exclude. |

## 3. Mapping onto `mise dot`

### Key constraints found

| Constraint | Consequence | Mark |
|---|---|---|
| Migrations edit with `sed -i` (no `--follow-symlinks`) and `awk > tmp && mv` | Both **replace a symlink with a regular file**, silently detaching it from the repo. | [i] from GNU sed / mv semantics |
| `omarchy-refresh-config` does `cp -f default user` | GNU `cp` writes *through* a destination symlink, so a refresh would **overwrite the repo source**. | [i] |
| `copy` mode overwrites the target on apply | Fights migrations: next `mise dot apply` reverts what a migration just did. | [d] |
| Edit entries refuse a symlink target; `merge` only for json/toml/yaml | gitconfig and lua need `block`/`line`, not `merge`. | [d] |
| Credential filter matches on file name only; `hosts.yml`/`age.txt` only under mise's config dir | `~/.config/gh/hosts.yml`, `~/.config/fnox/age.txt`, `gptme/server.env`, `Bitwarden CLI/data.json` would be saved **in plaintext** if a parent dir were tracked. `credentials*`, `oauth*` are caught. | [d] |
| `machine` variant on a tracked entry | Exactly the docs' example: `~/.config/hypr/monitors.lua`. Can't combine with `encrypt`. | [d] |

### Recommended mode per category

| Category | Files | Mode | Why |
|---|---|---|---|
| Append-only delta on omarchy files | `bindings.lua`, `looknfeel.lua`, `.bashrc`, `.bash_profile`, `tmux.conf` | `block` edit (`--` comment for lua, `#` otherwise) | Owns only skogix's lines; survives migrations and `omarchy-refresh-*` (re-apply puts the block back). This *is* "omarchy + delta". |
| Uncommented-template delta | `input.lua` | rewrite as an appended `block` with its own `hl.config{}` | Keeps the omarchy template pristine. Whether a second `hl.config` merges with omarchy's is [i], test first. |
| Structured omarchy files | `omarchy/shell.json`, `herdr/config.toml`, `opencode/opencode.json` | `merge = true` | Owns keys only. Note arrays are replaced whole, so the bar layout is owned as a unit. |
| git identity | `git/config` | `block` (or one `line` adding `[include] path = ...` to a skogix file) + `template` for email via `[vars]` | `merge` doesn't do gitconfig; the hardcoded gh 2.102.0 path wants a template or `gh auth setup-git` hook anyway. |
| Per-machine | `hypr/monitors.lua` (maybe `input.lua`) | `track` with `variants = [{ machine = true }]` | One version per host, never applied elsewhere. |
| skogix-only config | `fish/`, `atuin`, `worktrunk/config.toml`, `voxtype`, `zed`, `gita`, `spotifast`, `systemd/user/*.service|timer`, `nvim/lua/plugins/herdr-nvim.lua` | `symlink` / `symlink-each` from repo, or a `[dotfile_groups]` stow-style tree | Omarchy never touches them, so symlinks are safe. `symlink-each` for `fish/` and `systemd/user` so app/omarchy files beside them stay. |
| Secrets | `anthropic/credentials`, `gptme/oauth`, `gptme/server.env`, `Bitwarden CLI/data.json` | `track` + `encrypt = true`, or out of mise entirely | Encryption must be on before the first save. |
| Root keys / regenerable auth | `fnox/age.txt`, `fnox/identities`, `gh/hosts.yml` | **never** in mise history | `age.txt` is the key that would decrypt the rest; `gh` re-auths. Add explicit `mise dot exclude` globs. |
| Everything else | state/caches, omarchy-written state | nothing (or `track-local` if you want local undo) | — |

Simplest viable start (zero deploy machinery): `mode = "track"` on the ~10
omarchy files + skogix-only configs. Tracking leaves regular files, so
migrations keep working and their edits land in history as their own diffs.
Deploy entries (`block`/`merge`) are the step that makes a *fresh* omarchy
install reproduce the setup; tracking alone restores whole files and would
undo newer omarchy defaults.

## Surprises

- `~/.config/git/hooks` is a symlink into `~/claude/dotfiles/.config/git/hooks`
  (gptme agent dotfiles), but `core.hooksPath` is not set, so git never runs
  them. [v]
- `git/config` pins `gh` to `mise/installs/gh/2.102.0/...`: breaks on the next
  `mise up gh`. [v]
- `/usr/share/omarchy/version` says `4.0.0.alpha`; the package is 4.0.4. [v]
- An older dotfiles repo exists at `~/.local/src/.dotfiles` (i3/sway era,
  referenced in `bindings.lua` comments) with `fish`, `tmux`, `mise`,
  `worktrunk`, `zed`, `mimeapps.list`. Not compared here. [v]
- `fish/config.fish.before-skogai` suggests another tool already rewrote
  fish config once. [v]
