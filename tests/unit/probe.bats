#!/usr/bin/env bats

load ../helpers/fake-claude

setup() {
    setup_fake_claude
    P="$BATS_TEST_TMPDIR/p.jsonl"
}

@test "matching answer passes, exit 0, score line" {
    probe_line editor "what editor" 'nvim|neovim' >"$P"
    FAKE_CLAUDE_ANSWER="Neovim" run "$PROBE_BIN" "$P"
    [ "$status" -eq 0 ]
    [ "${lines[0]}" = "PASS editor: Neovim" ]
    [ "${lines[1]}" = "score 1/1" ]
}

@test "non-matching answer fails with expectation, exit 1" {
    probe_line editor "what editor" 'emacs' >"$P"
    FAKE_CLAUDE_ANSWER="nvim" run "$PROBE_BIN" "$P"
    [ "$status" -eq 1 ]
    [ "${lines[0]}" = "FAIL editor: nvim (expected /emacs/)" ]
    [ "${lines[1]}" = "score 0/1" ]
}

@test "mixed results across two files score partially" {
    probe_line a "q a" 'nvim' >"$P"
    probe_line b "q b" 'emacs' >"$BATS_TEST_TMPDIR/q.jsonl"
    FAKE_CLAUDE_ANSWER="nvim" run "$PROBE_BIN" "$P" "$BATS_TEST_TMPDIR/q.jsonl"
    [ "$status" -eq 1 ]
    [ "${lines[0]}" = "PASS a: nvim" ]
    [ "${lines[1]}" = "FAIL b: nvim (expected /emacs/)" ]
    [ "${lines[2]}" = "score 1/2" ]
}

@test "blank lines in a probe file are ignored" {
    { probe_line a "q" 'x'; echo; probe_line b "q" 'x'; } >"$P"
    FAKE_CLAUDE_ANSWER="x" run "$PROBE_BIN" "$P"
    [ "$status" -eq 0 ]
    [ "${lines[2]}" = "score 2/2" ]
}

@test "claude non-zero exit counts as FAIL with <error>" {
    probe_line a "q" 'UNKNOWN' >"$P"
    FAKE_CLAUDE_EXIT=3 run "$PROBE_BIN" "$P"
    [ "$status" -eq 1 ]
    [ "${lines[0]}" = "FAIL a: <error> (expected /UNKNOWN/)" ]
}

@test "claude timeout counts as FAIL with <error>" {
    probe_line a "q" 'UNKNOWN' >"$P"
    PROBE_TIMEOUT=1 FAKE_CLAUDE_SLEEP=5 run "$PROBE_BIN" "$P"
    [ "$status" -eq 1 ]
    [ "${lines[0]}" = "FAIL a: <error> (expected /UNKNOWN/)" ]
}

@test "multi-line answer is collapsed to one line before matching" {
    probe_line a "q" 'first second' >"$P"
    FAKE_CLAUDE_ANSWER='first\n\nsecond\n' run "$PROBE_BIN" "$P"
    [ "$status" -eq 0 ]
    [ "${lines[0]}" = "PASS a: first second" ]
}

@test "context files reach the system prompt after the instruction" {
    probe_line a "the question" 'x' >"$P"
    echo "CONTEXT-ONE" >"$BATS_TEST_TMPDIR/c1.md"
    echo "CONTEXT-TWO" >"$BATS_TEST_TMPDIR/c2.md"
    FAKE_CLAUDE_ANSWER=x run "$PROBE_BIN" -c "$BATS_TEST_TMPDIR/c1.md" \
        -c "$BATS_TEST_TMPDIR/c2.md" "$P"
    [ "$status" -eq 0 ]
    grep -q 'UNKNOWN' "$FAKE_CLAUDE_LOG"
    grep -q 'CONTEXT-ONE' "$FAKE_CLAUDE_LOG"
    grep -q 'CONTEXT-TWO' "$FAKE_CLAUDE_LOG"
    run grep -n -e 'reply exactly UNKNOWN' -e 'CONTEXT-ONE' "$FAKE_CLAUDE_LOG"
    [[ "${lines[0]}" == *UNKNOWN* ]]
}

@test "claude is called isolated with the question as prompt" {
    probe_line a "the question" 'x' >"$P"
    FAKE_CLAUDE_ANSWER=x PROBE_MODEL=sonnet run "$PROBE_BIN" "$P"
    [ "$status" -eq 0 ]
    local argv
    argv=$(grep '^ARGV:' "$FAKE_CLAUDE_LOG")
    [[ "$argv" == *"[-p]"* ]]
    [[ "$argv" == *"[--safe-mode] [--tools] []"* ]]
    [[ "$argv" == *"[--strict-mcp-config] [--no-session-persistence]"* ]]
    [[ "$argv" == *"[--model] [sonnet]"* ]]
    [[ "$argv" == *"[the question]" ]]
    local cwd
    cwd=$(sed -n 's/^CWD: //p' "$FAKE_CLAUDE_LOG")
    [ "$cwd" != "$PWD" ]
    [ ! -e "$cwd" ]
}

@test "model defaults to haiku" {
    probe_line a "q" 'x' >"$P"
    FAKE_CLAUDE_ANSWER=x run "$PROBE_BIN" "$P"
    grep -q '\[--model\] \[haiku\]' "$FAKE_CLAUDE_LOG"
}

@test "no probe file is a usage error" {
    run "$PROBE_BIN"
    [ "$status" -eq 2 ]
}

@test "unreadable probe file is a usage error" {
    run "$PROBE_BIN" "$BATS_TEST_TMPDIR/missing.jsonl"
    [ "$status" -eq 2 ]
}

@test "unreadable context file is a usage error" {
    probe_line a "q" 'x' >"$P"
    run "$PROBE_BIN" -c "$BATS_TEST_TMPDIR/missing.md" "$P"
    [ "$status" -eq 2 ]
}

@test "-c without a value is a usage error" {
    run "$PROBE_BIN" -c
    [ "$status" -eq 2 ]
}

@test "malformed json line is a usage error and claude is never called" {
    echo '{not json' >"$P"
    run "$PROBE_BIN" "$P"
    [ "$status" -eq 2 ]
    [ ! -e "$FAKE_CLAUDE_LOG" ]
}

@test "missing or extra field is a usage error" {
    echo '{"id":"a","question":"q","expect":"x"}' >"$P"
    run "$PROBE_BIN" "$P"
    [ "$status" -eq 2 ]
    echo '{"id":"a","question":"q","expect":"x","source":"s","more":"y"}' >"$P"
    run "$PROBE_BIN" "$P"
    [ "$status" -eq 2 ]
}

@test "non-string field is a usage error" {
    echo '{"id":1,"question":"q","expect":"x","source":"s"}' >"$P"
    run "$PROBE_BIN" "$P"
    [ "$status" -eq 2 ]
}

@test "duplicate id across files is a usage error before any call" {
    probe_line a "q" 'x' >"$P"
    probe_line a "q2" 'x' >"$BATS_TEST_TMPDIR/q.jsonl"
    run "$PROBE_BIN" "$P" "$BATS_TEST_TMPDIR/q.jsonl"
    [ "$status" -eq 2 ]
    [ ! -e "$FAKE_CLAUDE_LOG" ]
}

@test "zero probes is a usage error" {
    : >"$P"
    run "$PROBE_BIN" "$P"
    [ "$status" -eq 2 ]
}

@test "invalid regex is a usage error before any call" {
    probe_line a "q" 'x' >"$P"
    probe_line b "q" '(unclosed' >>"$P"
    run "$PROBE_BIN" "$P"
    [ "$status" -eq 2 ]
    [ ! -e "$FAKE_CLAUDE_LOG" ]
}

@test "a run prints only result lines and leaves no temp files" {
    probe_line a "q" 'x' >"$P"
    export TMPDIR="$BATS_TEST_TMPDIR/tmp"
    mkdir -p "$TMPDIR"
    FAKE_CLAUDE_ANSWER=x run "$PROBE_BIN" "$P"
    [ "$status" -eq 0 ]
    [ "${#lines[@]}" -eq 2 ]
    [ -z "$(ls -A "$TMPDIR")" ]
}

@test "claude gets /dev/null as stdin so it never waits for input" {
    probe_line a "q" 'x' >"$P"
    FAKE_CLAUDE_ANSWER=x run "$PROBE_BIN" "$P" <<<"stray input"
    [ "$status" -eq 0 ]
    grep -q '^STDIN: /dev/null$' "$FAKE_CLAUDE_LOG"
}
