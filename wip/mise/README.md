# mise

Research and a working example for using mise (and fnox) in skogai.

- [overview.md](overview.md) - ELI5 for programmers: tools, env vars, secrets, tasks, machine bootstrap.
- [who-and-mode.md](who-and-mode.md) - giving different callers different secrets, derived from Claude Code's own env vars.
- [gotchas.md](gotchas.md) - things that fail silently in mise and fnox.
- [example/](example/) - the who-and-mode setup as a self-contained project.

## Running the example

It needs the test identities in `~/.config/fnox/` (`age.txt`,
`identities/claude.txt`, `identities/skogix.txt`); the encrypted values in
`example/fnox.toml` only open with those.

```sh
cd wip/mise/example
mise trust
mise run whoami          # who=... mode=... profile=...
mise run deploy          # two shared secrets, redacted in output
mise run skogix-only     # refused when run from inside Claude Code
mise secrets ls          # names and which tasks receive them, never values
```

Inside the skogai repo the example also inherits the repo's own `mise.toml`.
Copy the two files elsewhere to run it in isolation.
