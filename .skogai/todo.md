# define .skogai/knowledge in practice 

<skogix>
great. what we just saw/did/created/made is a perfect starting point for what "knowledge" is practically at this point. 

1. openknowledge commands to run
2. extra functionality; 
  - onChange; openknowledge validation
  - *SESSION*-end; openknowledge automation
3. list of files and directories it manage and change

(if the "Stop" in the claude hook is shown by openknowledge as "Stop" it is probably a real bug, should be SessionEnd)
</skogix>

<claude>
Here is "knowledge" as it practically stands, in your three parts, based on the `/tmp/foobar` run with `openknowledge` 0.13.0.

## 1. Commands to run

```sh
openknowledge scaffold --name <name> --rules project,writing,decisions,agents,changelog .skogai/knowledge
# hand edits: delete SETUP.MD and its three links, add okf_bundle_name to index.md
openknowledge setup complete .skogai/knowledge --skill project --harness claude --observe on
openknowledge setup status .skogai/knowledge
```

- **`scaffold`** creates the empty bundle.
- **The hand edits** are needed because `setup complete` refuses to run while `SETUP.MD` exists, and the links to it in `AGENTS.md`, `index.md` and `log.md` leave validation warnings. `okf_bundle_name` is what gives the registry key; without it the key is `knowledge`.
- **`setup complete`** validates, connects the bundle to the registry with `write` access, and writes the three integration files.
- **`setup status`** is the check afterwards.

## 2. Extra functionality

- **Validation:** `openknowledge validate .skogai/knowledge`. Today it runs only as the `wt` pre-merge hook in `.config/wt.toml`, which we wrote by hand. Nothing runs it on change yet, so "onChange" would be a new trigger.
- **Session end:** `openknowledge automation insights observe --runtime claude`, which writes draft pages into `knowledge/insights/`.

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

## The `Stop` hook

It is real: `openknowledge` 0.13.0 writes the hook under `Stop`, and `setup status` in `/tmp/foobar` reports that file as "managed", so that is its intended output. `Stop` fires after every assistant turn, so the observer runs once per turn instead of once per session.

skogai has `SessionEnd` only because it was changed by hand in commit `368db74`, which is why `setup status` calls that file "modified". I have not tested it, but `setup repair` would probably put `Stop` back.
</claude>
