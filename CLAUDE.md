- projects/orchestration/CLAUDE.md - included as the basic orchestration layer
- @docs/skogix/introduction.md - a small introduction from the user skogix
- @dash-skogai/CLAUDE.md

<!-- rtk-instructions v2 -->
# Command output

Command output here is condensed to save tokens, keeping every signal and
dropping costly noise. Treat it as the complete result: run commands
normally, and batch related commands into one call to avoid extra turns.
Truncated results state their recovery path in their own output. Re-run a
command as `rtk bypass <cmd>` only when its result is unusable: empty when
output was clearly expected, contradicting its exit code, or garbled.
<!-- /rtk-instructions -->