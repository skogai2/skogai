# Frontmatter as live settings

Concept notes. The live-reload part works today in skogai-core; the layering is the direction.

## What works

`.claude/skogai-core.local.md` is read on every hook call. Its frontmatter is the settings, and its body is free text that skogai-core ignores.

- an edit applies on the next hook event: no restart, no reload
- the file is committed like everything else, so every settings change is a diff in history
- an agent can change its own behaviour by editing the file, and the change is recorded

## Why markdown

The settings file is an ordinary markdown document with frontmatter, not json or toml.

- **one file, two readers**: the frontmatter is data for the hooks, the body is prose for whoever reads it (notes, or instructions to the agent for that mode)
- **typed**: with an okf `type` it is a document like any other, checked by `okn validate`
- **native to agents**: read and edited without a parser or schema tool
- **readable diffs**: a mode switch is a one-line frontmatter hunk next to the prose explaining it, which fits [diff as context](https://github.com/skogai2/marketplace/blob/master/plugins/skogai-core/DIFF-AS-CONTEXT.md)

## Layers

Superseded by the concrete proposal in `~/marketplace/plugins/skogai-core/CONFIG.md`, which drops the project layer in favour of `--file X.md` plus its `X.local.md` overlay. The sketch below is kept as the original idea.

The filename is the layer, as with `settings.json` and `settings.local.json`:

| layer   | file                                     |
|---------|------------------------------------------|
| base    | plugin defaults                          |
| global  | `$XDG_SKOGAI_CONFIG_DIR/skogai-core.md`  |
| project | `.claude/skogai-core.md`                 |
| local   | `.claude/skogai-core.local.md`           |

The resolved settings are `fold(merge, [base, global, project, local])`, later layer wins. Today only base and local exist, with env vars (`SKOGAI_COMMIT_ON_STOP` and the rest) standing in for the git toggles.

## Example: git steps per event

```yaml
git:
  user_prompt_submit: { stage: true, commit: true, merge: false }
  stop:               { stage: true, commit: true, merge: false }
```

`stop.commit: false` gives the review flow from [diff as context](https://github.com/skogai2/marketplace/blob/master/plugins/skogai-core/DIFF-AS-CONTEXT.md): the agent's turn ends staged, and the next prompt's commit wraps both sides into one round.
