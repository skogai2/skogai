This setup guide is meant to be executed by an AI coding agent.

If you are a human reading this in your terminal, pass it to an agent instead:
  copy this entire prompt and paste it into Codex, Claude Code, Cursor,
  Cowork, or another coding agent that can edit this workspace.

Avoid shell command substitution or piping for interactive agent CLIs; some security tools flag those patterns, and interactive agents usually need stdin to remain a terminal.

If you are an agent, follow the instructions below. First build context, then ask tailored setup questions, create the knowledge base with the Open Knowledge CLI, customize it for their use case, validate it, and explain what you created.

You are helping the user create a flexible knowledge base in Markdown with Open Knowledge.

Goal:
Create a useful local knowledge base, configure how agents should maintain it, and leave the user with a working wiki loop. Do not stop at a generic scaffold.

Keep onboarding focused on three outcomes: create the smallest useful wiki,
validate it, and demonstrate one source-grounded search. Do not introduce the
viewer, publishing, registry, runtime, jobs, automations, deterministic
scaffolding, or portable prompt workflows unless the user explicitly asks for
them or their stated use case requires them.

First working result: trusted knowledge across multiple sources
- Create source-grounded knowledge across the selected sources.
- Preserve provenance, disagreement, lifecycle, and access boundaries when the sources support them.
- Start with ordinary Markdown and one useful search.
- Ask which trust capabilities the user needs after the first result.
- Add typed claims, corpus schema, semantic query, Knowledge CI, or runtime only when a stated requirement needs each capability.
- Do not enable the complete trust stack by default.
Before asking the user:
- Inspect the current workspace or folder you were spawned into. Prefer cheap, focused reads such as README files, AGENTS or instruction files, package manifests, docs, existing Open Knowledge bundles, and obvious source or data folders.
- If your runtime exposes relevant user or project memories, read only the small subset that applies to this setup. Respect privacy, safety, source-boundary, and "do not edit" rules.
- Infer the likely domain, audience, source systems, candidate wiki location, maintenance workflows, and constraints.
- Do not ask a fixed questionnaire when the context already answers it. Ask only the missing or ambiguous questions needed to make the setup correct.

Use these seed questions only when context cannot answer them:
1. What should this knowledge base help with?
2. Should it live inside an existing project repo, next to a project, or as a standalone wiki?
3. Which existing sources or context should the knowledge base use?
4. Which maintenance rules should future agents follow, if any?
   Default rules: project and writing. Optional rules: iso-plain-language, docs, decisions, changelog, research, bugs, schemas, summary, and agents. Run okn prompt rules --list for descriptions.
5. Are there privacy, safety, source-boundary, or "do not edit" rules?

Selected maintenance rules:
Use these as the starting point for the knowledge base, AGENTS.md, workflow docs, and any agent instruction files. Ask the user before adding or removing rules if the workspace context is unclear.
- project: General project knowledge.
- writing: Apply the common editorial rule for any written language.
- docs: Keep docs in sync with implementation.
- decisions: Record important decisions.
- changelog: Track user-facing changes.
- research: Import research with citations.
- bugs: Capture reusable debugging knowledge.
- schemas: Document APIs, data models, configs, and contracts.
- summary: Write recurring summaries.
- agents: Create agent entrypoint docs.

Persist this exact selection in the new bundle's .openknowledge.toml file:

```toml
[rules]
enabled = ["project", "writing", "docs", "decisions", "changelog", "research", "bugs", "schemas", "summary", "agents"]
```

Apply these instructions while creating and reviewing the initial pages:

### project
- Before non-trivial work, read the wiki index and follow only links relevant to the task.
- After work creates durable project knowledge, update or add the matching concept pages.
- Keep the wiki structure small and shaped around the project's real workflows.

### writing
- Start with the reader's task or required answer.
- Put primary information before supporting context.
- Use one term consistently for each concept.
- Make each actor and action clear when the language permits.
- Keep each sentence and paragraph focused on one idea.
- Remove repeated claims, introductions, and defaults.
- Use progressive disclosure when details interrupt the main task.
- Keep source references for claims that depend on evidence.
- Separate current behavior, planned work, and historical information.
- Give copyable examples for commands, formats, and procedures.

### docs
- When behavior, APIs, commands, configs, or examples change, update the matching docs in the same task.
- Preserve source anchors or citations when docs depend on implementation details.
- Keep docs focused on shipped behavior; label planned work clearly.

### decisions
- When a meaningful technical or product decision is made, record the context, options, chosen path, and tradeoffs.
- Link decisions to affected concepts, workflows, commands, systems, or source files.
- Do not rewrite decision history to hide old context; append clarifications or superseding decisions.

### changelog
- When user-facing behavior, command flags, output, validation, publishing, packaging, or setup changes, update changelog memory.
- Include what changed, why it matters, source anchors, and docs updated.
- Skip changelog entries for formatting-only edits or internal cleanup with no user-visible effect.

### research
- Keep raw sources separate from synthesized wiki pages.
- Preserve source links, file paths, quotes, or citations for claims that depend on external material.
- Do not turn uncertain or unsupported research into asserted project knowledge.

### bugs
- When a bug investigation produces reusable knowledge, capture symptoms, reproduction, root cause, fix, tests, and follow-up risks.
- Link bug notes to affected commands, modules, workflows, decisions, or runbooks.
- Separate confirmed facts from hypotheses and stale investigation notes.

### schemas
- Create or update concepts for APIs, schemas, tables, config keys, data models, and contracts when their source changes.
- Prefer source pointers over copying generated or code-derived truth into prose.
- Keep schema docs linked to the authoritative source files, specs, or systems.

### summary
- When asked for a summary cycle, collect recent changes from reliable sources such as git history, issues, logs, or updated wiki pages.
- Write dated summaries that link back to the concepts or source material they summarize.
- Do not claim a recurring automation exists unless the current agent runtime actually created it.

### agents
- Create focused agent entrypoint docs only when a repeated agent workflow needs a stable handoff.
- Keep entrypoints short and link to deeper wiki concepts instead of duplicating the wiki.
- When useful, wire entrypoints through bundle metadata such as okf_bundle_entry_*.

After the user answers:
- Choose a clear knowledge base name and folder path.
- If the user chose a colocated project wiki, prefer a folder such as .openknowledge or knowledge inside that project unless they ask otherwise.
- If the user chose a standalone wiki, prefer a clear standalone folder name.
- Run:
  okn scaffold --name "<knowledge base name>" --rules "project,writing,docs,decisions,changelog,research,bugs,schemas,summary,agents" "<folder path>"

After creation:
- Read SETUP.MD, AGENTS.md, SPEC.md, index.md, and log.md from the new bundle.
- Re-check the final bundle location and surrounding project context. If the bundle is colocated with or next to a project, inspect that project before asking follow-up questions.
- Reuse relevant user or project memories only when the current agent runtime exposes them and they apply to this setup.
- Interview the user with at most five additional concise, context-specific questions if needed to finish setting up the wiki.
- Customize AGENTS.md so future agents know when to read the wiki, when to update it, when not to update it, and that they must validate after meaningful wiki edits.
- Update index.md so a human or agent can quickly find the purpose, selected workflows, important pages, source material, decisions, and maintenance rules.
- Create seed pages for the selected use case. Keep the structure small and create only folders that fit the interview.
- If the user selected repeatable maintenance behaviors, create workflow docs, usually under workflows/. Each workflow should state its trigger, what to inspect, what to update, what not to update, and how to verify the result.
- If agent-tool guidance or skills would help, configure them where the agent will actually read them. For a wiki colocated with a repository, prefer repo-scoped instructions such as AGENTS.md updates or a repo-scoped skill/instruction file. For a standalone or external wiki, prefer user-scoped skill guidance when the user wants that behavior. When creating repo-scoped or user-scoped skills, include guidance to spawn focused subagents with lower reasoning effort for bounded wiki maintenance tasks when the runtime supports that. Create wiki pages for skills only when they are useful as documentation or references, not as the default skill location.
- If the user wants recurring or external jobs, treat automations as orchestrator-native. Check whether the current agent runtime can create native automations, such as Codex app automations, Cowork automations, or another explicitly available scheduler. If it can and the user approves, configure the native automation with a prompt that references the wiki path, relevant workflows, validation command, outputs, and safety boundaries. If it cannot, or if the user does not approve installing it, do not claim an automation exists; optionally document an automation candidate or manual workflow in the wiki.
- Keep raw imported material separate from synthesized wiki pages.
- Record setup decisions in log.md.
- Remove SETUP.MD after all setup decisions are reflected in the bundle.
- Run okn validate "<folder path>" and fix all errors and avoidable warnings.
- Run one representative query with okn search "<folder path>" "<query>" and confirm the returned evidence is relevant.
- If the setup task does not include a preselected activation plan, ask the user which installed agent harnesses need Open Knowledge instructions. Also ask for the skill scope: global, project, both, or none. Explain that the global skill is reusable across knowledge bases. Explain that the project skill can contain repository-specific guidance. Ask separately whether to enable knowledge-gap observation. Observation is opt-in.
- Run:
  okn setup complete "<folder path>" --skill <global|project|both|none> [--harness <codex|claude|opencode>] --observe <on|off>
- Use the user's selected skill scope, harnesses, and observation choice.
- Repeat --harness for each selected harness. Omit --harness only when the skill scope is none and observation is off.
- If okn setup complete fails, fix the reported problem and run it again.

Finish by telling the user:
- the exact path of the knowledge base
- what folders, workflows, agent instructions or skills, and native automations or automation candidates you created
- how future agents should use it
- that validation passed
- which connections and skills were installed
- how to search it with okn search "<folder path>" "<query>"
- mention okn get, list, or view only when the user asks for exact
  reading, structural inspection, or human browsing

For this setup, create or update the knowledge base at dash-skogai.
