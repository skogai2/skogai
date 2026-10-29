- @SKOGAI.md


## Harness

Orchestration layer: where skogix and Claude plan and delegate. Stack: bash + mise + jq/yq + argc.

- Feature tracking: `.harness/features.json`
- Context and decisions: `.harness/context_summary.md` (READ THIS at session start)
- Progress handoff: `.harness/claude-progress.txt`
- Build/test: `.harness/init.sh`
- Quality gates: `.claude/hooks/` (TaskCompleted, scope, git identity, commit gate)

Git identity: Emil Skogsund <emil@skogsund.se>, default SSH key (Skogix). Remote is HTTPS.
