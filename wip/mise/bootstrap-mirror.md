# bootstrap mirror

A `mise.toml` whose bootstrap sections describe what this machine already
has, so `plan` / `status` should report nothing to change. It's an example
and a syntax check. Don't apply it. File:
[example-bootstrap/mise.toml](example-bootstrap/mise.toml).

Done on 2026-10-14 with local `mise 2026.10.9` on omarchy 4.0.4. The docs
and source came from `tmp/mise`, which is at 2026.10.10. Only read-only
commands were run, from a scratch copy: `mise trust`, `plan`, `status`,
`--dry-run`, `--help`.

## Result

| Command | Result |
|---|---|
| `mise bootstrap plan` | `1 create, 0 update, 43 unchanged, 0 remove, 0 unknown`. The create is the flatpak bug below. |
| `mise bootstrap status` | Everything is `installed`, `unchanged`, `current` or `set`, except `flatpak-user:com.nvidia.geforcenow` (missing) and `shell fish` (missing). `--missing` exits 1. |
| `mise bootstrap --dry-run` | Would run `flatpak install --user ...` and `edit ~/.config/fish/config.fish (block:activate)`. Everything else says "already installed / converged / current / set". |
| Same, with `fish = false` and no flatpak entry | `Plan: 0 create ... 43 unchanged`. `status --missing` exits 0, and the dry run changes nothing. |

`plan` covers only packages, files, services, firewall and Compose. Repos,
shell, user and tools appear only in `status` and `--dry-run`.

The global `~/.config/mise/config.toml` is layered in. It has no bootstrap
sections, but its 27 `[tools]` show up in `status` as the `tools` part, and
all of them are installed.

## Syntax: answers to the earlier gaps

| Section | Entry | Verified |
|---|---|---|
| `[bootstrap.packages]` AUR | `"aur:<pkgname>" = "latest"`. Uses `yay`, or `paru` if yay is missing (this machine has yay only). | run |
| `[bootstrap.packages]` Flatpak | `"flatpak:<app-id>"` is system-wide, `"flatpak-user:<app-id>"` is per user. Only `"latest"` is accepted, and remotes are not managed. | run (bug below) |
| `[bootstrap.repos]` | `"<path>" = { url = "...", ref = "..." }`. `ref` is optional, and without it the checkout is never moved. `~/` and absolute paths work everywhere. Relative paths work only in a project config. Keys can use `{{ vars.x }}` templates (added in .9). | run (`current`) |
| `[bootstrap.user]` | `login_shell = "/usr/bin/fish"`. The path must be absolute. mise adds it to `/etc/shells` and runs `chsh`. | run (`set`) |
| `[bootstrap.mise_shell_activate]` | `fish = "auto"` (activate when interactive, shims otherwise). Also accepts `true`, `false`, `"activate"`, `"shims"` and `{ enabled, mode }`. It always writes `~/.config/fish/config.fish`. | run |
| `[bootstrap.services.<name>]` system | `state = "running"/"stopped"`, `enabled`, `masked`, `on_change`. Only for units that already exist. Changes go through sudo, but checking needs none. | run (`unchanged`) |
| `[bootstrap.services.<name>]` user | `scope = "user"`, `command`, `restart`, `environment`, ..., or `builtin = "history-watch"/"tool-update"` | docs, plus one plan probe |
| `[bootstrap.linux.systemd.units.<name>]` | systemd keys in snake_case (`exec_start`, `wanted_by`, timer keys, ...) | docs only |

### Package classification used

| Group | Count | Entry form |
|---|---|---|
| omarchy baseline: `omarchy-{base,other}.packages`, `omarchy-pkg-add` hardware scripts, deps of the `omarchy` package | 159 | **left out** |
| user-added, `extra`/`multilib` | 21 | `pacman:` |
| user-added, from the `[omarchy]` pacman repo (claude-desktop, omazed, voxtype-bin, ...) | 6 | `pacman:` |
| installer/hardware (efibootmgr, intel-ucode, mkinitcpio, sudo, lib32-vulkan-intel) | 5 | `pacman:` |
| foreign (`pacman -Qqem`) | 7 | `aur:` |
| flatpak, user scope | 1 | `flatpak-user:` |

Telling the baseline apart worked well. The only judgement call was the
installer group: archinstall puts those packages there, and omarchy's lists
don't name them.

## Changes in 2026.10.7 to 2026.10.10 that matter here

| Version | Change |
|---|---|
| .5 (before this range) | `fish = "auto"` added |
| .9 | Docs now *recommend* `fish = "auto"` for fish |
| .9 | Elevation: if `sudo` is missing, mise falls back to `run0` (systemd 256+), then `doas`. `system_packages.elevate_with = "run0"` pins one. AUR helpers still call sudo themselves. |
| .9 | `[bootstrap.repos]` paths are rendered as templates. The schema now accepts `[bootstrap.secrets]`, `[bootstrap.users]` and `[bootstrap.groups]`. |
| .10 (not installed here) | `snap:` manager, `--adopt <url>?ref=<branch>`, `[bootstrap.dnf.repos]`. Nothing Arch-specific. |

## Gotchas found

**systemd user units can't be mirrored.** User services and
`[bootstrap.linux.systemd.units]` only manage `~/.config/systemd/user/dev.mise.<name>.*`.
mise never adopts an existing unit. A probe with
`[bootstrap.services.voxtype] scope = "user"` planned `create user-service:voxtype`,
which would write a second unit. System services do adopt existing units,
but `[bootstrap.services.bt-agent]` (a user unit) came back
`unknown: unit not found`, because system scope looks only at the system
manager. The 17 enabled user units are listed as a comment in the example.

**Repo packages must not use `aur:`.** `aur:` checks `pacman -Qm`, so a
package from the `[omarchy]` repo shows `create aur:omazed`, and applying it
would rebuild the package from the AUR over the repo version. The reverse is
safe: `pacman:spotifast-bin` (an AUR package) shows `unchanged`, because the
check is plain `pacman -Q`. So `pacman:` is fine for mirroring anything that
is installed, but `apply` would fail on a fresh machine for AUR names.

**Flatpak apps with no version always show as missing** (2026.10.9, flatpak
1.18.2). `flatpak list --user --columns=application,version` prints
`com.nvidia.geforcenow\n` with no tab when the version is empty.
`parse_flatpak_list` in `src/system/packages/flatpak.rs` uses
`split_once('\t')` and drops that line. The fix belongs upstream.

**Existing fish activation isn't recognised.** This machine activates mise in
`~/.config/fish/conf.d/00_mise_activate.fish`. mise writes only to
`config.fish` and skips that only for a `[dotfiles]` entry on the same path,
so `fish = "auto"` reports `missing`. Applying it would activate mise twice.
Either delete the conf.d file and let mise own it, or set `fish = false`.

**Pins on pacman/aur/flatpak show as `unknown`**, not as a change:
`(manager cannot install pinned versions)`. Use `"latest"`.

**`system_packages.sudo = false` in project `[settings]` is accepted**
without a warning. The example sets it as a guard.

## Not verified here

- `apply` of anything. Nothing was applied.
- `[bootstrap.linux.systemd.units]` and `scope = "user"` services against a
  real unit (docs plus one `plan` probe only).
- `run0`/`doas` fallback (sudo is installed here).
- `mise bootstrap packages where`, `prune` and `unapply`.
