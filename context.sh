#!/usr/bin/env bash
cat ./context/message-history/* > ./context/MESSAGE-HISTORY.md
cat ./context/system-prompt/* > ./context/SYSTEM-PROMPT.md
echo '<skogai_generated_context>' > ./tmp/aaa.md
echo '</skogai_generated_context>' > ./tmp/zzz.md
date > ./tmp/date.md
git diff > ./tmp/git-diff.md
cat ./tmp/*.md > ./CONTEXT.md
cat ./context/MESSAGE-HISTORY.md >> ./CONTEXT.md

