---
permalink: skogai/skogai
type: router
---

<routes>

  - projects/skogai-routing/skills/skogai-routing/AGENTS.md - skogai-routing: the origin skill. What a SKOGAI.md file is, how routing works, and the meaning behind dash-skogai (`/skogai`), dot-skogai (`~/.skogai`), and skogfences (skogai2/skogai-routing)
  - projects/dot-skogai - dot-skogai: the `.skogai` convention (skogai2/dot-skogai), the bootstrap folder for any project (repo now empty, the reference was removed in d6b9fac)
  - projects/dash-skogai/README.md - dash-skogai: the shared state. Holds `config.defaults.json` and `fish/config.fish`, which every repo installs from. `/skogai` itself is not provisioned yet
  - ~/claude/CLAUDE.md - claude: Claude Code's own agent home
  - ~/dot/AGENTS.md - dot: dot's own home (skogai2/dot)   
  - ./projects/config/SKOGAI.md - config: env vars/aliases/keybinding config (skogai2/config)
  - ./projects/skogai-cli/docs/CONFIG.md - skogai-cli: the `skogai` command. Config model: dash-skogai pins, the `.skogai` store, install. Env rules are in docs/ENV.md
  - @./TOOLS.md - the tools on this machine (herdr, wt, gh, gptodo, gptme-coordination, ...), what each is for, and how skogai uses it
  - ./SKOGAI.md: this repo itself (skogai2/skogai) — the front-door index you're reading now

</routes>

