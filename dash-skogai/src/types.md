---
type: Draft
title: types
description: types to be defined, before they land in corpus_schema
---

# types

types which should be defined
fill in more headers for potential types to be discussed 

## type

the concept of a type itself: what a type is, and what every type definition has to define. in okf, `type` is the one required frontmatter key, with free-form values (spec §4.1).

once `corpus_schema` is present in the root `index.md`, the union is closed: a type definition is one `document_types` entry (`id`, `aliases`, `paths`, `required`), and an undeclared `type` value fails `okn validate`. the entry shape is owned by okn and pinned by `version`. we append entries but cannot add fields, so skogai extensions go in a sibling `skogai_schema` key.

## decision

## rule

## trigger

## tool

## task

## knowledge

## memory

## repo

## spec

