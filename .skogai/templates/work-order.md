---
name: <slug-name>
description: <concise-one-line-summary>
reads:
  - <repo-relative-path/file1.ext>
  - <repo-relative-path/file2.ext>
owns:
  - <repo-relative-path/file-to-modify-or-create.ext>
---

# Work Order: <slug-name>

## Intent
<!-- Why is this work needed? What problem does it solve? What is the architectural context? -->
<Describe the background, motivation, and goal of this change.>

## Deliverables
<!-- What concrete artifacts must exist upon completion? Must map 1:1 with 'owns'. -->
- `<repo-relative-path/file-to-modify-or-create.ext>`: <Exact description of changes, new functions, or file content.>

## Acceptance Criteria
<!-- Verifiable, deterministic commands and assertions. Every command must pass. -->
- Command: `<exact-bash-command-1>`
  - Expected exit code: `0`
  - Expected output / assertion: `<expected-output-or-effect>`
- Command: `<exact-bash-command-2>`
  - Expected exit code: `0`

## Boundaries & Non-Goals
<!-- What must NOT be done? Strict boundaries to prevent scope widening. -->
- **Out of Scope**: <Explicitly list adjacent features, refactorings, or files that must not be touched.>
- **Anti-Widening Directive**: If completing this task requires creating or modifying any file outside the `owns` list, STOP immediately, make no out-of-scope modifications, and report the blocking dependency back to the orchestrator.
- **Environment**: Do not bypass permission prompts, do not install unpinned packages, and do not access external network resources.

## Verification & Reporting
<!-- What information must the agent report upon completion? -->
Upon completion, the assigned agent must report:
1. Git branch (`wo/<name>`) and commit hash.
2. Summary of changes made to each file in `owns`.
3. Verbatim execution logs and exit codes for every Acceptance Criteria command.
4. Any caveats, edge cases discovered, or follow-up recommendations.
