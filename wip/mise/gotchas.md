# Gotchas

Things that failed silently or cost time on 2026-10-11, with `mise 2026.10.6`
and `fnox 1.39.0`. All were reproduced here except the two marked *(docs)*.

## mise

**`{$VAR}` is not `${VAR}`.** A typo in a directive path is not an error. The
file just doesn't exist, and missing files are skipped without a warning.

```toml
_.source = "{$SKOGAI_SCRIPTS_ENV_DIR}/env.sh"   # silently never sourced
_.source = "${SKOGAI_SCRIPTS_ENV_DIR}/env.sh"   # works
```

The same goes for `_.file` pointing at a file that isn't there. Check with
`mise config ls` and `mise env`.

**`MISE_ENV` can't be set from `[env]`.** mise chooses which
`mise.<env>.toml` files to load before it evaluates `[env]`, so this exports
the variable and loads nothing:

```toml
[env]
MISE_ENV = "claude"        # mise.claude.toml is NOT loaded
```

What does select an environment: `MISE_ENV` in the real environment,
`-E claude`, or `.miserc.toml`:

```toml
# .miserc.toml
env = ["claude", "workstation"]    # several are allowed
```

`.miserc.toml` does not expand templates, and a real `MISE_ENV` overrides it.

**Shims apply `[env]`.** Running a tool through a mise shim loads the
project's `[env]` first, so a variable exported by hand is overwritten:

```sh
FNOX_AGE_KEY_FILE=/other/key fnox get X    # still uses the path from mise.toml
```

**Tools are per project.** A tool declared only in a project's `mise.toml`
fails through its shim outside that project (`No version is set for shim`).
Use `mise -C <project> x -- <tool>` or add it globally.

**Redaction hides values from output only.** A task with `secrets = [...]`
prints `[redacted]`, but the process has the real value.

## fnox

**`fnox set -d` with a piped value stores no value.** The description is
saved and the value is dropped, with a success message:

```sh
printf %s "v" | fnox set -d "desc" KEY     # KEY = { description = "desc" }, no value
fnox set -d "desc" KEY v                   # stores the value
printf %s "v" | fnox set KEY               # stores the value
```

**Adding a recipient doesn't re-encrypt.** Existing secrets stay encrypted to
the old recipient list until you run `fnox reencrypt`, using an identity that
can still read them.

**An inline `FNOX_AGE_KEY` beats everything**, including a provider's
`key_file` and `identity`. Useful for containers, surprising if one is left
exported in a shell.

**age can't use ssh-agent** *(docs)*. An SSH key works as an age identity only as an
unencrypted private key file. Passphrase-protected SSH keys aren't supported.

**The daemon caches resolved values** *(docs)*. A changed secret keeps its old value
until `fnox daemon clear` or `fnox get --refresh KEY`. Use `--no-daemon` when
testing who can decrypt what.

**`fnox remove` on a keychain secret leaves the keychain entry.** The config
line goes; the OS keychain item stays until removed with `secret-tool clear`.

## Claude Code cloud sessions

Reproduced on 2026-10-11 with `mise 2026.10.7`.

**The GitHub API only answers for repos attached to the session.** Calls to
`api.github.com` for any other repo get a 403 ("GitHub access to this
repository is not enabled for this session"); release *downloads* from
`github.com` still work. `github:` tools log a WARN on version listing but
still install. Plain `fnox` (the `packslip:` backend) does not: it fetches a
skill through the contents API and fails the whole install with "declared
skill(s) fnox are not installed". Use `"aqua:jdx/fnox"` or `"github:jdx/fnox"`.

**A failed decryption still runs the task.** Without an identity, `mise run
deploy` logs a WARN per secret and runs with the variables empty.

**`mise secrets` needs `experimental = true`**, otherwise every task with
`secrets = [...]` refuses to run.

**The setup script's shell state is gone by the time Claude runs.** `export`,
`eval "$(mise activate bash)"` and `cd` in the setup script don't reach the
Bash tool, and `mise trust` / `mise install` act on whatever directory the
script happens to start in. See `current-claude-code-setup-script.sh` for
what persists: global mise settings, and a shims line at the top of
`~/.bashrc` (above its non-interactive early return).

**Shims give you the tools, not the `[env]`.** A plain Bash tool call sees
none of the repo's `[env]` (`SKOGAI_*`, `FNOX_PROFILE`); only `mise run`,
`mise x` and shimmed tools load it. To get it everywhere, export it to a
file (`mise env -s bash > file`) and point Claude Code at it with
`CLAUDE_ENV_FILE`, which is run before each Bash command.
