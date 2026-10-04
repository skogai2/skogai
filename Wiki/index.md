---
okf_version: "0.2"
type: Index
title: Skogai Wiki
description: Entry point for the Skogai front-door knowledge base.
tags: [skogai, index]
---

# Skogai Wiki

This wiki documents the `skogai` front-door repo (`skogai2/skogai`): what it
holds, how its routes work, and how to keep it current.

Read this page first. Follow only the links that match your task.

## Start here

* [Overview](overview.md): what the repo contains and what it does not.
* [Agent rules](AGENTS.md): how agents read and update this wiki.
* [Log](log.md): dated history of changes to the wiki.
* [Guides](guides/index.md): walkthroughs of the Open Knowledge tooling and this setup.

## Sections

* [Architecture](architecture/index.md): routing model and the current route list.
* [Projects](projects/index.md): submodules and routing notes under `projects/`.
* [Workflows](workflows/index.md): repeatable maintenance procedures.

## Source material

* `SKOGAI.md` and `AGENTS.md` at the repo root.
* `projects/SKOGAI-ROUTING-GLOSSARY.md` and `projects/SKOGAI-ROUTING-INTENTIONS.md`.
* `.gitmodules` and the two submodules under `projects/`.

No raw imports exist yet. If raw material is added later, store it in a separate `raw/` folder.

## Decisions

No decision records yet. Open questions and intentions live in
`projects/SKOGAI-ROUTING-INTENTIONS.md`.

## Maintenance rules

Enabled rules are `project` and `writing`. They are defined in
[AGENTS.md](AGENTS.md) and `.openknowledge.toml`.
