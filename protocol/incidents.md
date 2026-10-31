# Incidents

## 2026-10-29: ~/.config/mise/config.toml rewritten, secrets published

### What happened
- answer: At 12:41 an unknown writer rewrote ~/.config/mise/config.toml (mise history
  checkpoint 787). Nested arrays and inline tables became strings, and the quoted-key
  `[bootstrap.*]` tables were dropped. Dotfiles entries were then re-added without
  their include/exclude filters.
- source: `git show 593de0b:.harness/context_summary.md` Gotchas; mise history repo
- learned: 2026-10-29

### Impact
- answer: Without the filters, the next `mise dotfiles sync` published secrets to the
  dotfiles repo (skogai2/.dotfiles on GitHub).
- source: `git show 593de0b:.harness/context_summary.md` Gotchas
- learned: 2026-10-29

### What was done
- answer: The filters were restored (checkpoint 825), and skogix rotated the exposed
  secrets, so the published values are dead.
- source: `git show 593de0b:.harness/context_summary.md` Gotchas
- learned: 2026-10-29

### Still open
- answer: The dead secret values remain in the dotfiles repo's git history (purge
  skipped). The writer that rewrote the file is still unidentified. The file "changes
  constantly", so the dotfiles watcher saves it only every 24h, which delays capture
  of the next bad rewrite.
- source: `git show 593de0b:.harness/context_summary.md` Gotchas; `mise dotfiles status` and `mise dot paths --noisy`
- learned: 2026-10-29

### Lesson
- answer: When restoring a config, restore its filters first. An entry without its
  excludes is worse than a missing entry.
- source: `git show 593de0b:.harness/context_summary.md` Meta-Patterns
- learned: 2026-10-29
