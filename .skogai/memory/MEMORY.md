# Memory

Local memory (decision 0007): anything, written freely, maintained. Each
entry has a `stale_after`; on expiry it becomes knowledge, state, an action,
or is forgotten.

* [offer-dont-install](offer-dont-install.md) - skogai offers opt-in, never takes over another tool's files.
* [concepts-not-mechanisms](concepts-not-mechanisms.md) - definitions name concepts, never mechanisms.
* [openknowledge-insights-are-memory](openknowledge-insights-are-memory.md) - insights/ is memory inside the bundle; openknowledge loose ends.
* [always-commit](always-commit.md) - commit finished changes without asking, only my files.
* [temporary-paths](temporary-paths.md) - .skogai/logs and tmp are throwaway; defaults are opt-in.
* [fleet-persona-not-roleplay](fleet-persona-not-roleplay.md) - skogai-fleet: personas are seats for many models; relationships drive and sink; KRONSCH test.
* [dotfiles-via-mise-tools](dotfiles-via-mise-tools.md) - dotfiles/history: mise's own commands only, never raw git/systemctl on its store.
* [names-lowercase-one-segment](names-lowercase-one-segment.md) - lowercase; a name is one segment, `.`/`_` are relations.
* [functional-state-as-diff](functional-state-as-diff.md) - user is a functional programmer; state is a diff on a base, every key has a default.
* [trust-existing-systems](trust-existing-systems.md) - use pacman/git/etc. where they fit; never reinvent the wheel.
* [swap-internals-keep-interface](swap-internals-keep-interface.md) - swapping internals keeps the user's command; check on the real setup, not only tests.
* [skogai-runner-is-a-command-runner](skogai-runner-is-a-command-runner.md) - "runner" = command runner (argc/make); skogai 3.0 focuses on core, other modules removed from master on purpose.
* [rejection-is-a-value](rejection-is-a-value.md) - invalid input is an answer, not an error exit; same output whatever exists.
* [read-vendored-docs-first](read-vendored-docs-first.md) - read a repo's docs/ before designing; use the tool's own features, one step at a time.
* [session-path-not-config](session-path-not-config.md) - wrong `which`/PATH: compare a clean login shell first; skogai env lines are session-only.
* [understand-before-fixing](understand-before-fixing.md) - demos are for my understanding, never offer fixes; skogparse emits skogai-notation, not json.
* [skogai-notation-runtime](skogai-notation-runtime.md) - skogparse/skogcli config: $ refs, @ actions, missing @ is intent for an agent; aichat hooks.
* [studio-harvest](studio-harvest.md) - studio base is 675d6fc; todo-branch gamemaker dump is harvest material, concept level first.
* [subagent-briefs-are-mine](subagent-briefs-are-mine.md) - orchestration: brief + judge are the hard part; preconditions, clean env, mechanical stops.
* [no-chained-commands](no-chained-commands.md) - one command per Bash call; chains defeat narrow permission rules.
* [track-then-trim](track-then-trim.md) - dotfiles: unsure means track, trim noise within the hour; outside ~/.config too; agents start read-only.
* [secrets-burned-on-contact](secrets-burned-on-contact.md) - secrets that touched git or an agent are already rotated; only history rewrite is open.
* [claude-tool-allowlist](claude-tool-allowlist.md) - /skogai clean claude: tools allowlisted per surface (deny always wins), verify via stream-json init.
* [probe-method-lessons](probe-method-lessons.md) - protocol probes, spec gates (testable is not worth) and herdr agents; harness removed 2026-10-31.
