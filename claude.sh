#!/usr/bin/env bash
export MAX_THINKING_TOKENS=0 
bash context.sh
echo '<skogai_input>' >> ./CONTEXT.md
echo "$@" >> ./CONTEXT.md
echo '<skogai_input>' >> ./CONTEXT.md
CONTEXT=$(cat CONTEXT.md)
claude -p --no-session-persistence --model=haiku --tools='' --safe-mode --setting-sources='project' --system-prompt-file='./context/SYSTEM-PROMPT.md' "${CONTEXT}" > ./RESPONSE.md

