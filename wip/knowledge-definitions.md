# Knowledge — practical definition

Draft. What "knowledge" is in practice for a skogai repo today: the commands
that set it up, the functionality it adds, and the files it manages.

Verified on 2026-10-11 by running the setup in an empty git repo
(`/tmp/foobar`) with `openknowledge` 0.13.0, and comparing the result with
skogai.

## 1. Commands to run

```sh
openknowledge scaffold --name <name> --rules project,writing,decisions,agents,changelog .skogai/knowledge
# hand edits: delete SETUP.MD and its three links, add okf_bundle_name to index.md
openknowledge setup complete .skogai/knowledge --skill project --harness claude --observe on
openknowledge setup status .skogai/knowledge
```

- `scaffold` creates the empty bundle.
- The hand edits are required:
  - `setup complete` refuses to run while `SETUP.MD` exists.
  - `AGENTS.md`, `index.md` and `log.md` each link to `SETUP.MD`; the links
    leave validation warnings after the file is deleted.
  - `okf_bundle_name` in the `index.md` frontmatter gives the registry key.
    Without it the key is the folder name, `knowledge`, which is the same
    for every repo.
- `setup complete` validates the bundle, connects it to the registry with
  `write` access, and writes the three integration files.
- `setup status` is the check afterwards. `setup repair` restores managed
  files.

## 2. Extra functionality

| Trigger | Command | State |
|---|---|---|
| on change | `openknowledge validate .skogai/knowledge` | Runs only as the `wt` pre-merge hook in `.config/wt.toml`, written by hand. Nothing runs it on change yet. |
| session end | `openknowledge automation insights observe --runtime claude` | Installed by `setup complete` as a Claude hook. Writes draft pages into `knowledge/insights/`. |

Also available once the bundle is connected: `openknowledge search|get|list <key>`
from any directory, through the registry.

## 3. Files and directories it manages

| Path | Written by | Tracked in `integration.toml` |
|---|---|---|
| `.openknowledge/integration.toml` | `setup complete` | it is the manifest |
| `.claude/settings.json` (the hook only) | `setup complete` | yes, `claude_hook` |
| `.claude/skills/openknowledge/SKILL.md` (managed block only) | `setup complete` | yes, `project_skill` |
| `.skogai/knowledge/.openknowledge.toml` | `scaffold` | no |
| `.skogai/knowledge/{index,log,AGENTS,SPEC}.md` | `scaffold` | no |
| `.skogai/knowledge/insights/` | the observe hook | path only |
| `~/.config/openknowledge/registry.json` | `setup complete` | no, user level |

`integration.toml` records the bundle path, insights path, harness,
observation on/off, and a sha256 for each managed file.

Not created by `openknowledge`, added by hand in skogai:

- `.config/wt.toml` — the pre-merge validation hook.
- The route chain that loads the index at session start:
  `AGENTS.md` → `SKOGAI.md` → `.skogai/SKOGAI.md` → `.skogai/ROUTES.md` →
  `@knowledge/index.md`. `openknowledge` itself loads nothing into context.
- The `log.jsonl` line in `.gitignore`.
- The `permissions` block in `.claude/settings.json`.

## Known issues

- **Hook event is `Stop`, should be `SessionEnd`.** `openknowledge` 0.13.0
  writes the observe hook under `Stop`, which fires after every assistant
  turn. skogai was changed to `SessionEnd` by hand in commit `368db74`, so
  `setup status` reports its `settings.json` as "modified". Untested:
  `setup repair` probably puts `Stop` back.
- **Registry key defaults to `knowledge`.** `scaffold --name` does not write
  `okf_bundle_name`; see the hand edits above.
- **Scaffold leaves dangling `SETUP.MD` links.** See the hand edits above.
