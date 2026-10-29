# Prepends the fake claude to PATH and gives each test a scratch dir and log.
setup_fake_claude() {
    PROBE_BIN=$(realpath "$BATS_TEST_DIRNAME/../../bin/probe")
    if [ -n "${PROBE_KCOV_DIR:-}" ]; then
        PROBE_BIN=$(realpath "$BATS_TEST_DIRNAME/../helpers/probe-under-kcov")
    fi
    PATH="$BATS_TEST_DIRNAME/../helpers/fake-claude:$PATH"
    FAKE_CLAUDE_LOG="$BATS_TEST_TMPDIR/claude.log"
    export PATH FAKE_CLAUDE_LOG
    unset FAKE_CLAUDE_ANSWER FAKE_CLAUDE_EXIT FAKE_CLAUDE_SLEEP PROBE_MODEL PROBE_TIMEOUT
}

probe_line() {
    jq -cn --arg id "$1" --arg q "$2" --arg e "$3" \
        '{id: $id, question: $q, expect: $e, source: "test"}'
}
