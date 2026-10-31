# Protocol

What an agent needs to know to work on and recover this system, learned on the job.
Most answers start as UNKNOWN and get filled in when something happens or changes.

## Entry format

Every entry has four parts:

- **situation**: the question or situation, as a heading
- **answer**: what is known, or the literal word `UNKNOWN` when it is not known yet
- **source**: the command, file or person it was learned from
- **learned**: the date it was learned or last confirmed

Unknowns are written down, never left out: an `UNKNOWN` entry is a gap to fill.

```markdown
### <situation>
- answer: <answer | UNKNOWN>
- source: <command, file or person>
- learned: <YYYY-MM-DD>
```

## Redaction

Entries may quote command names, subcommands, flags and well-known config or repo
paths. They never quote argument values from shell history (free text, URLs, tokens),
env var values or file contents.

## Sections

| File | Holds |
|---|---|
| incidents.md | What went wrong, its impact, what was done, what is still open |
| tools.md | Tools installed vs actually used |
| information.md | Where docs, configs and repos live |
| solutions.md | How things actually get done |
| breaks.md | What fails, how often, and why |
| scale.md | Size of the system and the trade-offs of each layer |

## Testing

Each section has probes in `tests/probes/<feature>.jsonl`: a question and the expected
answer, established from ground truth before the entry is written. `bin/probe` asks a
fresh claude with no tools and only these files. Run all with
`bin/probe $(printf -- '-c %s ' protocol/*.md) tests/probes/*.jsonl`.

## Open

### Network is down: who is contacted, and over which channel?
- answer: UNKNOWN
- source: skogix
- learned: 2026-10-29
