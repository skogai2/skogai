# Who and mode: secrets that follow the caller

How one repo config gives different secrets to different callers, without
anyone setting a flag. Worked out on 2026-10-11 with `mise 2026.10.6` and
`fnox 1.39.0`. The runnable version is in [example/](example/).

## The idea

Two questions decide what a process may read:

| Question | Values | Answered by |
|---|---|---|
| **Who** is running? | `claude`, `skogix` | Is `CLAUDECODE` set? |
| **Mode**: where is it running? | `workstation`, `remote` | Is `CLAUDE_CODE_REMOTE` `true`? |

Claude Code sets both variables itself, so the config reads them and nobody
has to pass `-E` or export `MISE_ENV`.

| Variable | Set when (Claude Code docs, `env-vars.md`) |
|---|---|
| `CLAUDECODE=1` | In everything Claude Code spawns: Bash tool, hooks, status line, stdio MCP servers. IDE extensions also set it in their integrated terminals. |
| `CLAUDE_CODE_CHILD_SESSION=1` | Only in subprocesses Claude Code itself starts (v2.1.172+). Not in MCP servers or IDE terminals. |
| `CLAUDE_CODE_REMOTE=true` | In cloud sessions. Never set locally. |

`CLAUDE_CODE_ENTRYPOINT` exists in the environment (`cli` locally) but is not
documented, so nothing here depends on it.

## The mise side

Who and mode are plain `[env]` templates. `FNOX_PROFILE` is derived the same
way, and `[secrets.fnox]` with no `profile =` picks it up.

```toml
[env]
SKOGAI_USER = "{% if env.CLAUDECODE is defined %}claude{% else %}skogix{% endif %}"
SKOGAI_MODE = "{% if env.CLAUDE_CODE_REMOTE is defined and env.CLAUDE_CODE_REMOTE == 'true' %}remote{% else %}workstation{% endif %}"

FNOX_PROFILE = "{% if env.CLAUDECODE is defined %}claude{% else %}skogix,claude{% endif %}"
FNOX_AGE_KEY_FILE = "{{env.HOME}}/.config/fnox/age.txt"
FNOX_DAEMON = "on"

[secrets.fnox]

[tasks.deploy]
secrets = ["MY_TEST_SECRET", "SKOGAI_MY_TEST_SECRET"]
run = "./deploy.sh"
```

A task only receives the keys it lists. The shell, hooks and `mise env` get
none of them.

## The fnox side

One provider per audience, one profile per user. Profiles stack:
`FNOX_PROFILE=skogix,claude` loads both, later ones winning on conflicts, with
the top-level `[secrets]` as the base.

```toml
default_provider = "workstation"

[providers.workstation]            # everyone on this machine
type = "age"
recipients = ["age1...claude", "age1...skogix", "age1...workstation"]

[providers.claude]
type = "age"
key_file = "~/.config/fnox/identities/claude.txt"
recipients = ["age1...claude"]

[providers.skogix]
type = "age"
key_file = "~/.config/fnox/identities/skogix.txt"
recipients = ["age1...skogix"]

[secrets]                          # in every profile
MY_TEST_SECRET = { provider = "workstation", value = "..." }

[profiles.claude.secrets]
CLAUDE_ONLY_SECRET = { provider = "claude", value = "..." }

[profiles.skogix.secrets]
SKOGIX_ONLY_SECRET = { provider = "skogix", value = "..." }
```

Where fnox looks for the age identity, first match wins:

1. `FNOX_AGE_KEY` (the identity inline)
2. the provider's `identity = { provider = "...", value = "..." }`
3. the provider's `key_file`
4. `FNOX_AGE_KEY_FILE`
5. `~/.config/fnox/age.txt`

That order is what makes the modes work without separate config:

| Mode | How the identity arrives | Config needed |
|---|---|---|
| `workstation` | Key files on disk (3 and 4) | as above |
| `remote` | `FNOX_AGE_KEY` injected into the container (1) | none; it overrides the rest |
| keychain or Bitwarden | `identity = { provider = "keychain", value = "claude-age-identity" }` (2) | replaces `key_file` |

## What was tested

Run from a standalone copy of [example/](example/):

| Caller | `deploy` | `claude-only` | `skogix-only` |
|---|---|---|---|
| Claude Code (`CLAUDECODE=1`) | ok | ok | refused: not in the `claude` profile |
| Human (`CLAUDECODE` unset) | ok | ok | ok |
| Remote, simulated (`CLAUDE_CODE_REMOTE=true`, claude's key in `FNOX_AGE_KEY`) | ok | ok | refused |

The keychain route was tested separately: with the identity stored in the OS
keychain, a secret decrypted with no key file and no env var, and an injected
`FNOX_AGE_KEY` still took precedence.

Not tested: a real cloud session, Bitwarden as the identity provider, and a
profile-level provider override for the shared provider's identity.

## Limits

- **Local isolation is by profile, not by cryptography.** Claude and the human
  are the same OS user, so claude's processes can read
  `identities/skogix.txt` and run `fnox -P skogix`. Only the remote case, where
  the container holds just claude's key, separates them for real.
- **`CLAUDECODE` is also set in IDE terminals.** A human typing in a VS Code
  terminal resolves to `claude` and gets the narrower profile. Switching to
  `CLAUDE_CODE_CHILD_SESSION` fixes that but makes MCP servers resolve to the
  human, which is the wider profile.
- **`SKOGAI_MODE` is only a label.** Nothing branches on it yet; the remote
  behaviour comes entirely from `FNOX_AGE_KEY` being present.
- **The task does not get the identity.** mise injects the listed secrets but
  not `FNOX_AGE_KEY`, so a script that calls `fnox get` itself fails in
  remote mode.

## Earlier approach, and why it was dropped

The first version selected who and mode with config environments:
`mise.claude.toml`, `mise.skogix.toml`, `mise.workstation.toml`,
`mise.remote.toml`, `mise.user.toml`, chosen by `MISE_ENV=<who>,<mode>` with a
default in `.miserc.toml`. It worked, but someone had to set `MISE_ENV`, and
it can't be computed: mise picks the files before it evaluates any `[env]`
or template. Deriving who and mode inside `[env]` needs no selection at all.
