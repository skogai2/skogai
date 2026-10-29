#!/bin/bash
# Harness init.sh - bash/mise/jq orchestration layer
# Usage: .harness/init.sh [smoke_test|full_test|machine_check|probe_test|coverage|focused_test <test_file>]
# Default: full_test
#
# smoke_test   — bash -n on tracked *.sh, jq parse on tracked *.json (<15s).
# focused_test — run one bats file. Exit 0 = executed and passed; exit 3 =
#                skipped (missing file or not a .bats file); anything else
#                is a real failure. A runner's own exit 3 is remapped to 1.
# full_test    — smoke_test plus every bats file under tests/unit/ (fixture
#                driven, machine independent).
# machine_check — bats files under tests/machine/ against the live machine.
#                Never part of full_test: machine drift is a finding, not a
#                broken build.
# probe_test   — bin/probe with every protocol/*.md as context over every
#                tests/probes/*.jsonl. Live claude calls; never part of
#                smoke_test or full_test.
# coverage     — tests/unit under kcov, scoped to bin/; report outside the repo.

set -e

TARGET=${1:-full_test}
FOCUS_FILE="${2:-}"

if [ "$TARGET" = "focused_test" ] && [ -z "$FOCUS_FILE" ]; then
    echo "focused_test requires a test file argument" >&2
    exit 2
fi

PROJECT_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$PROJECT_ROOT"

echo "=== Harness ${TARGET} ==="
echo "Project: $PROJECT_ROOT"
echo "Date: $(date -u +%Y-%m-%dT%H:%M:%SZ)"
echo ""

tracked() {
    git ls-files -- "$@" | grep -v -e '^tmp/' -e '/tmp/' -e '^\.claude/hooks/' || true
}

smoke() {
    local failed=0 f
    echo "--- bash -n ---"
    while IFS= read -r f; do
        [ -f "$f" ] || continue
        bash -n "$f" || { echo "syntax error: $f"; failed=1; }
    done < <(tracked '*.sh')
    echo "--- jq parse ---"
    while IFS= read -r f; do
        [ -f "$f" ] || continue
        jq empty "$f" >/dev/null 2>&1 || { echo "invalid json: $f"; failed=1; }
    done < <(tracked '*.json')
    return $failed
}

protocol_context() {
    local f
    for f in protocol/*.md; do
        [ -f "$f" ] && printf -- '-c %s ' "$f"
    done
}

run_focused() {
    local rc=0
    "$@" || rc=$?
    if [ "$rc" -eq 3 ]; then
        rc=1
    fi
    return $rc
}

case "$TARGET" in
    smoke_test)
        smoke
        ;;
    focused_test)
        if [ ! -f "$FOCUS_FILE" ]; then
            echo "focused_test: test file '$FOCUS_FILE' does not exist -- skipped (exit 3)."
            exit 3
        fi
        case "$FOCUS_FILE" in
            *.bats) run_focused bats "$FOCUS_FILE" ;;
            *.jsonl) run_focused bin/probe $(protocol_context) "$FOCUS_FILE" ;;
            *)
                echo "focused_test: no runner for '$FOCUS_FILE' -- skipped (exit 3)."
                exit 3
                ;;
        esac
        ;;
    full_test)
        smoke
        echo "--- bats tests/unit ---"
        if [ -d tests/unit ] && [ -n "$(find tests/unit -name '*.bats' -print -quit)" ]; then
            bats -r tests/unit
        else
            echo "no bats tests under tests/unit/ yet"
        fi
        ;;
    machine_check)
        echo "--- bats tests/machine ---"
        if [ -d tests/machine ] && [ -n "$(find tests/machine -name '*.bats' -print -quit)" ]; then
            bats -r tests/machine
        else
            echo "no bats tests under tests/machine/ yet"
        fi
        ;;
    probe_test)
        echo "--- bin/probe protocol/ x tests/probes ---"
        bin/probe $(protocol_context) tests/probes/*.jsonl
        ;;
    coverage)
        out="${TMPDIR:-/tmp}/skogai-kcov"
        rm -rf "$out"
        mkdir -p "$out/runs"
        PROBE_KCOV_DIR="$out/runs" bats -r tests/unit
        kcov --merge "$out/merged" "$out"/runs/run.* >/dev/null
        jq -r '.files[] | "\(.file | sub(".*/skogai/"; "")) \(.percent_covered)%"' \
            "$out"/merged/kcov-merged/coverage.json
        ;;
    *)
        echo "unknown target: $TARGET" >&2
        exit 2
        ;;
esac

echo ""
echo "=== ${TARGET} Complete ==="
