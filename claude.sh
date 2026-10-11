#!/usr/bin/env bash
export MAX_THINKING_TOKENS=0
claude -p --no-session-persistence --model=haiku --tools='' --safe-mode --setting-sources='project' --system-prompt-file='./context/SYSTEM-PROMPT.md' < ./CONTEXT.md > ./RESPONSE.md
