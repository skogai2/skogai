---
name: fleet-persona-not-roleplay
description: "skogai-fleet direction - personas are seats for many (often small/local) models, relationships are the engine and the leak, KRONSCH is the noise floor."
metadata:
  node_type: memory
  created: 2026-10-17
  stale_after: 2026-12-17
  originSessionId: ad2d9acc-1eb0-4627-8c5a-d7391e675d1c
  modified: 2026-10-17T10:40:12.283Z
---

skogix, 2026-10-17, on skogai-fleet (~/.local/src/skogai-fleet, remake of
the nelson plugin): only the persona files were changed, as a proof of
concept. Upstream filled gaps with code and it became a "pirate themed
workflow management system". The rework goes back to the roots: ride the
associations LLMs make, good and bad - persona over scripting, markdown only.

The five points, in skogix's order:
1. relationships drive a system like this forward;
2. relationships also sink the ship fastest;
3. the intent is NOT Claude role-playing 20 characters for prose at the end;
4. smaller/local agents sit at every stage, from checking JSON formatting
   up to planning meetings with Claude, other captains and skogix;
5. the base is each agent's prompt, personal belongings (its markdown
   files) and arguments - the wave the crew solves problems on.

KRONSCH: a ~50-token phonetic guard-dog persona, skogix's long-running
"prompt noise" probe. The culture test: cut an agent's self-introduction
and let KRONSCH (a small model) continue it; if it continues in the same
direction the culture is shared, if not the speaker must simplify. What
survives the noise floor is signal. Source: .old-references/chat.md.

**Why:** themed vocabulary over mechanisms gives the model no associations;
one big model narrating every character flanderizes.

**How to apply:** treat a persona file as the prompt for one seat on one
model sized to fit it, not as lore for Claude to perform. Judge persona
text by whether it survives the smallest model in the relationship. Don't
propose scripts to fill gaps. Related: [[concepts-not-mechanisms]].

On expiry: fold into fleet design notes, or forget.
