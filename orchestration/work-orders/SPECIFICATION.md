# Work Order Specification & Lifecycle Standard

This document defines the normative standard for creating, validating, dispatching, and completing Work Orders in Skogai (`/home/skogix/skogai`).

---

## 1. Core Architecture: Separation of Task Specification from Runtime Targets

Work orders are declarative, portable capability contracts. They define **what** work must be accomplished, the contextual inputs required to perform it, and the strict boundaries of permissible file modifications.

### The Decoupling Mandate
Work orders must **never** specify or hardcode execution targets or runtime environments. Physical machines, Herdr workspaces, terminal tabs, panes, ephemeral worktree checkout paths, agent process names, model families, and git branches are dynamic runtime assignments made by the orchestrator at dispatch time.

Embedding runtime targets in work orders creates brittle, non-portable specifications that fail upon workspace reloads, multi-machine handoffs, or parallel execution. By keeping work orders target-agnostic, any compliant work order can be executed by any supported agent kind across any available worktree or pane.

---

## 2. Work Order File Format & Schema

A work order is a Markdown file with a YAML frontmatter block enclosed by `---` delimiters.

### 2.1 YAML Frontmatter Schema

| Field | Type | Requirement | Constraints & Format | Description |
|---|---|---|---|---|
| `name` | String | **Mandatory** | Lowercase kebab-case: `^[a-z0-9]+(-[a-z0-9]+)*$` (3–48 chars) | Unique identifier slug for the work order. Used as branch suffix (`wo/<name>`), worktree label, and agent naming. |
| `description` | String | **Mandatory** | Single-line string, max 120 chars | Concise summary in active voice, present tense. Used in commit summaries and pull request descriptions. |
| `reads` | List of Strings | **Mandatory** | Array of repository-root-relative file paths. No leading `/`, no `..`, no wildcard globs. | Prioritized context files the assigned worker agent must read before beginning work. |
| `owns` | List of Strings | **Mandatory** | Non-empty array of repository-root-relative file paths. No directories, no leading `/`, no `..`, no wildcard globs. | The exclusive write set. The worker agent is strictly forbidden from creating, modifying, or deleting any file outside this list. |
| `status` | String | Optional | Enum: `draft`, `open`, `in-progress`, `completed`, `rejected` | Lifecycle state. Inferred from directory location (`open/`, `completed/`) if omitted. |
| `depends_on` | List of Strings | Optional | List of work order `name` slugs | Upstream work orders that must reach `completed` status before this work order can enter `open`. |
| `tags` | List of Strings | Optional | List of lowercase labels (e.g. `[orchestration, docs]`) | Categorization and filtering tags. |

#### Frontmatter Example:
```yaml
---
name: contract-yq-flavor
description: Refuse non-mikefarah yq in contract checker instead of treating all files as invalid YAML
reads:
  - src/core/contract/argc.sh
  - tests/contract.bats
  - mise.toml
owns:
  - src/core/contract/argc.sh
  - tests/contract.bats
---
```

### 2.2 Strictly Forbidden Frontmatter Fields

The following fields represent transient execution targets or runtime state. Their presence in any work order file is strictly prohibited and constitutes an immediate validation failure:

```yaml
# FORBIDDEN - MUST NOT APPEAR IN WORK ORDERS
workspace: <id>     # Ephemeral Herdr workspace ID (e.g., w94)
pane: <id>          # Ephemeral Herdr pane ID (e.g., w94:p1)
tab: <id>           # Ephemeral Herdr tab ID (e.g., w94:t1)
machine: <host>     # Target host, node name, or SSH profile
worktree: <path>    # Filesystem checkout directory path
agent: <name>       # Ephemeral agent process name
kind: <kind>        # Agent engine flavor (e.g., claude, codex, gemini)
model: <model>      # LLM model identifier
socket: <path>      # Daemon IPC socket path
branch: <branch>    # Git branch name
pr: <number>        # Pull request identifier
base: <ref>         # Base git ref (defaults to master)
```

---

## 3. Standardized Body Structure

The body of each work order must contain exactly five canonical Level 2 sections (`##`), in this precise order:

### 3.1 `## Intent`
- **Purpose**: Architectural background, motivation, and problem statement.
- **Content**: Explains why this work is needed, what design trade-offs exist, and how it fits into the broader system architecture.

### 3.2 `## Deliverables`
- **Purpose**: Concrete functional and structural requirements.
- **Content**: Details the exact functions, files, schemas, APIs, or behaviors to implement. Every listed artifact must map 1:1 to a file path declared in `owns`.

### 3.3 `## Acceptance Criteria`
- **Purpose**: Verifiable, deterministic, automated gates.
- **Content**: Explicit shell commands that must be executed (e.g. `mise exec -- bash -n <file>`, `bats <test>`, `test -f <file>`), expected exit codes (Exit 0), and observable assertions. All criteria must be machine-executable and falsifiable.

### 3.4 `## Boundaries & Non-Goals`
- **Purpose**: Explicit negative boundaries to prevent scope widening.
- **Content**: Enumerates adjacent modules, tools, or behaviors that must not be altered. Must include the mandatory **Anti-Widening Directive**:
  > **Anti-Widening Directive**: If completing this task requires creating or modifying any file outside the `owns` list, the agent must STOP immediately, make no out-of-scope edits, and report the blocking dependency back to the orchestrator.
- Also specifies runtime constraints (e.g., no package installation, no external network access, no bypassing permission dialogs).

### 3.5 `## Verification & Reporting`
- **Purpose**: Standardized worker completion report format.
- **Content**: Specifies the exact report packet the worker must return upon completion:
  1. Git branch (`wo/<name>`) and commit hash.
  2. Summary of modifications made to each file in `owns`.
  3. Verbatim stdout/stderr logs and exit codes from running all Acceptance Criteria commands.
  4. Documented caveats, edge cases discovered, or follow-up recommendations.

---

## 4. The 5-State Lifecycle Model

Work orders progress through five discrete lifecycle states, tracked via directory queues and orchestrator runtime state:

```
                  ┌─────────┐
                  │  draft  │
                  └────┬────┘
                       │ T1: Queue Admission (Validation Gates)
                       ▼
                  ┌─────────┐
                  │  open   │ ◄─── (in open/ queue)
                  └────┬────┘
                       │ T2: Dynamic Dispatch (Worktree & Agent Lease)
                       ▼
               ┌───────────────┐
               │  in-progress  │ (tracked in orchestrator runtime registry)
               └───┬───────┬───┘
                   │       │
    T3: Acceptance │       │ T4: Boundary Violation or Irrecoverable Failure
       Passes      │       │
                   ▼       ▼
            ┌───────────┐ ┌──────────┐
            │ completed │ │ rejected │
            └───────────┘ └──────────┘
             (completed/)  (rejected/)
```

### 4.1 Lifecycle States

1. **`draft`**: Work order is being authored, scoped, or reviewed. Resides in `./tmp/` or local author workspace. Not eligible for dispatch; not evaluated by concurrency conflict checkers.
2. **`open`**: Work order is validated against the schema, verified for disjoint `owns` paths against all other open orders, and placed in `orchestration/work-orders/open/<name>.md`. Ready for dispatch.
3. **`in-progress`**: Work order has been dispatched to a worker agent. The orchestrator holds an active lease in its runtime registry (`.registry.json`). The work order file in `open/` remains unmodified.
4. **`completed`**: Worker completed the task. The orchestrator verified that all changed files are within `owns` (`git diff --name-only <= owns`), independently executed all Acceptance Criteria commands to confirmation, merged the branch, moved the work order file to `orchestration/work-orders/completed/<name>.md`, and deprovisioned runtime resources.
5. **`rejected`**: Worker halted due to an unresolvable boundary block, invalid specification, or failed acceptance tests that cannot be remediated within scope. Resources are deprovisioned without git merge, and the order is moved to `orchestration/work-orders/rejected/<name>.md` with failure diagnostics.

### 4.2 State Transitions & Gates

| Transition | From State | To State | Mandatory Preconditions & Gates |
|---|---|---|---|
| **T1: Queue Admission** | `draft` | `open` | 1. Schema check passes (mandatory fields present, no forbidden keys).<br>2. All files in `reads` exist on the target base ref.<br>3. `owns` contains only specific relative file paths (no directories, no globs).<br>4. Disjointness gate passes: $\text{owns}(W) \cap \bigcup_{O \in \text{Open}} \text{owns}(O) = \emptyset$.<br>5. All work orders listed in `depends_on` are present in `completed/`. |
| **T2: Dynamic Dispatch** | `open` | `in-progress` | 1. Orchestrator acquires execution lock in runtime registry.<br>2. Worktree workspace provisioned (`herdr worktree create --no-focus`).<br>3. Worker agent instantiated in auto mode (`herdr agent start`).<br>4. Dispatch prompt packet submitted (`herdr agent prompt --wait`). |
| **T3: Land & Complete** | `in-progress` | `completed` | 1. Worker reports task completion.<br>2. Diff audit gate: `git diff --name-only` is strictly a subset of `owns`.<br>3. Independent verification: orchestrator re-runs all Acceptance Criteria commands with Exit 0.<br>4. Git merge: branch merged into master.<br>5. File transition: `git mv orchestration/work-orders/open/<name>.md orchestration/work-orders/completed/<name>.md`.<br>6. Teardown: `herdr worktree remove`. |
| **T4: Rejection / Abort** | `in-progress` | `rejected` | 1. Worker halted on boundary block or unresolvable failure.<br>2. Worktree and pane closed without merging branch.<br>3. Failure rationale recorded; file moved to `rejected/` or retired. |

---

## 5. Dynamic Orchestrator Runtime Binding

Because work orders contain zero execution targets, the orchestrator binds runtime resources dynamically at dispatch time.

### 5.1 Runtime Binding Separation
The orchestrator dynamically allocates:
- **Worktree Path**: `~/.herdr/worktrees/<repo>/<branch>`
- **Branch Name**: `wo/<name>`
- **Workspace ID**: Herdr workspace handle (e.g. `w94`)
- **Pane ID**: Herdr terminal pane handle (e.g. `w94:p1`)
- **Agent Process**: Agent name (e.g. `wo-<name>`) and kind (e.g. `claude`, `codex`, `gemini`)

These bindings are maintained in orchestrator session memory or an ephemeral, gitignored runtime registry file (e.g., `./tmp/work-order-registry.json`), **never written into the work order Markdown file**.

### 5.2 Dispatch Prompt Packet Contract
The orchestrator compiles a self-contained dispatch prompt packet delivered to the worker agent via `herdr agent prompt`:

```text
ASSIGNMENT: Work Order '<name>'
SPECIFICATION FILE: orchestration/work-orders/open/<name>.md
WORKING DIRECTORY: <worktree_path>

BOUNDARIES & SCOPE:
- Required reading: inspect all files declared in 'reads'
- Strictly OWNED files:
    <file1>
    <file2>
- You are strictly FORBIDDEN from modifying any other file in this repository.
- Anti-Widening Directive: If completing this task requires creating or modifying any file outside 'owns', STOP immediately and report the blocking dependency.

EXECUTION INSTRUCTIONS:
1. Read the specification file and context files first.
2. Implement deliverables matching all Acceptance Criteria.
3. Run every Acceptance Criteria command inside your worktree.
4. When finished, submit your final report detailing branch, commit, modified files, and verbatim test output.
```

---

## 6. Concurrency Safety via Disjoint Ownership

### 6.1 The Disjoint Ownership Invariant
Let $\mathcal{Q} = \{W_1, W_2, \dots, W_n\}$ be the set of all work orders currently in `orchestration/work-orders/open/`:
$$\forall i, j \in \{1, \dots, n\}, \quad i \neq j \implies \text{owns}(W_i) \cap \text{owns}(W_j) = \emptyset$$

Parallel execution of multiple coding agents is safe if and only if no two active agents modify the same file. When ownership sets are strictly disjoint, sub-agents can execute concurrently in isolated Git worktrees without merge collisions or unpredictable state interference.

### 6.2 Granularity & Validation Rules
1. **File-Level Granularity**: Every entry in `owns` must be an explicit, individual file path. Directory paths (e.g. `src/`) and wildcard globs (e.g. `src/*.sh`) are strictly forbidden because string-matching checkers cannot reliably detect overlapping file edits inside directory trees.
2. **Normalized Relative Paths**: All paths in `reads` and `owns` must be relative to the repository root, with no `./` prefixes, no duplicate slashes, and no parent directory references (`..`).
3. **Serial Chaining for Shared Files**: If two work orders must modify the same file (e.g. `AGENTS.md`), they cannot be `open` concurrently. The second order must declare `depends_on: [<first-order>]` and remain in `draft` until the first order transitions to `completed`.
4. **Pre-Dispatch Static Conflict Check**: Before admitting any work order to `open/`, the orchestrator verifies:
   ```bash
   NEW_OWNS=$(yq eval '.owns[]' "$CANDIDATE_FILE")
   EXISTING_OWNS=$(yq eval '.owns[]' orchestration/work-orders/open/*.md 2>/dev/null)
   CONFLICTS=$(comm -12 <(echo "$NEW_OWNS" | sort -u) <(echo "$EXISTING_OWNS" | sort -u))
   if [ -n "$CONFLICTS" ]; then
     echo "ERROR: Ownership conflict detected with existing open work order:" >&2
     echo "$CONFLICTS" >&2
     exit 1
   fi
   ```
5. **Post-Execution Forensic Audit**: At completion, the orchestrator audits the actual git diff against `owns`:
   ```bash
   MODIFIED_FILES=$(git -C "$WORKTREE_PATH" diff --name-only "$BASE_COMMIT"...HEAD)
   for file in $MODIFIED_FILES; do
     if ! grep -q "^$file$" <(printf '%s\n' "${OWNS_ARRAY[@]}"); then
       echo "BOUNDARY VIOLATION: Sub-agent modified unowned file: $file" >&2
       exit 1
     fi
   done
   ```
   Any change to an unowned file results in immediate rejection of the work order and rejection of the git merge.
