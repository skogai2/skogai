# skogix

hi claude. I'd like to continue with some discussions about dot and dash skogai focusing on "dash is a singleton / template / class and dot is the implementation or instance" into actually defining the basics enough to start building a cli / workflow 

# claude

Here is a proposal to react to.

## Taking class/instance literally

| OOP | skogai | CLI verb |
|---|---|---|
| class definition | dash: the layout plus the types | none (edited by PR) |
| constructor | create a `.skogai` from dash | `skogai init` |
| `instanceof` | does this `.skogai` conform to dash | `skogai check` |
| reflection | list the members and where each value comes from | `skogai status` |
| static members | global knowledge and memory: one value, lives in dash | read only |
| instance fields | local knowledge, memory, state, config | owned by the dot |
| methods | `bin/`: defined once in dash, run against a dot | `skogai <name>` |

`init`, `check` and `status` are enough for a v0. Update (dash to dot) and promote (dot to dash, already in 0007) can come later.

## The one missing definition: member

Dash has to declare each layout entry as a member with a name, a type, and one of three kinds:

- **shared**: one value that lives in the class, and instances only point at it (the glossary, global memory).
- **default**: the class supplies the initial value, and the instance owns it afterwards (`ROUTES.md`, config).
- **own**: the class declares only that it exists and its type, and the content is the instance's (local knowledge, workorders, state).

With that, `init` creates the defaults, `check` verifies that members exist and are typed, and `status` prints the kind of each member. This is step 0 of `wip/ground-up-order.md` made concrete, and it names no mechanism.

## Decisions I need from you

1. **Is `~/.skogai` a parent or a peer?** Either the chain is dash → `~/.skogai` → `<repo>/.skogai` (inheritance), or every dot instantiates dash directly. I recommend peer, because the chain brings back the machine-bound layer that 0005 moved away from.
2. **Are undeclared members an error or a candidate?** "Everything in dot is by definition also in dash" suggests strict. I recommend that `check` flags them as candidates to promote or remove, so a dot can experiment without failing.
3. **Is dash both the class and its own single instance?** That is how I read "singleton": `/skogai` holds the definitions and the shared values. If so, `/skogai` is never checked as a dot.
4. **Where does the CLI live?** I recommend `bin/skogai` in dash, since a method belongs to the class, with skogai-cli retired or reduced to its source. The alternative is to revive skogai-cli.

Do the three member kinds match how you think about it? Everything else depends on that.

# skogix

now the reason for describing it like that was to get the point across - oop being simpler and more mainstream in this regard.

if i were to instead say that the keywords should be "functional, idempotency, immutable and strict types" a lot of things change design wise :)

# claude

Yes, and mostly it gets simpler. Several of my questions disappear rather than get answered.

## What changes

| OOP framing | Functional framing |
|---|---|
| dash is a singleton holding state | dash is a **value at a revision**: type definitions plus pure functions. Many revisions can coexist. |
| dot is an object with mutable fields | dot is a **value of type `Skogai`**, typed against one dash revision. |
| `init` and `update` are separate | one function, `apply(definition, dot) → dot`, with `apply(apply(x)) = apply(x)`. Init is `apply` on an empty dot. |
| `check` is lenient and flags candidates | `check` is a **type checker**. An undeclared member is a type error. Experiments go in a type that permits them (memory), not in looser checking. |
| parent or peer | no longer a question. Nothing inherits; every dot is `f(definition@rev, its own sources)`, and `~/.skogai` is one more value. |
| shared / default / own | **source** or **derived**. Source is authored and typed. Derived is the output of a function, is never hand-edited, and can be deleted and regenerated. |

The source/derived split is what 0005 already says about checkouts being disposable, applied inside a `.skogai`. It also covers your todo item `decisions/*.md → DECISIONS.md`: that file is derived.

## The CLI

- `skogai check`: pure, returns the type errors.
- `skogai plan`: pure, returns the diff that `apply` would make.
- `skogai apply`: the only writer. It executes the plan and is idempotent.

Everything else (triggers, tools) becomes functions that run on an event and go through the same `plan` and `apply`.

## What blocks building

Strict types make step 1 of `wip/ground-up-order.md` (**type**) the real blocker, because a type definition must now be checkable, not prose. My proposal is that every type states three things: its fields and their types, whether it is source or derived, and its mutability.

## Decisions I need from you

1. **Is source/derived the single split?** If yes, the three member kinds are dropped.
2. **How does local memory fit immutability?** Decisions, events and landed workorders are already write-once. Local memory is "maintained", which means edited in place. I recommend supersede-not-edit: a new entry replaces the old one, and expiry is a function over `stale_after`.
3. **Does a dot pin a dash revision or follow head?** I recommend pinning. Then `check` is reproducible, and moving to a newer dash is an explicit `apply` with a visible plan.

# skogix

- if i say "dot is more alike a discriminated union of skogai-types" would it make sense? 
- dont know the correct term for what essentially is "apply / set state from base case -> global -> local" or simply how lets say most env/config/settings work. maybe that is what you meant by "its own sources" instead of parent/peer?

now "open knowledge format" is the reason for why im thinking over a lot of things from earlier versions of skogai. essentially adding the thinking around types to markdown files all the way. example:

```okn list
|   |-- AGENTS.md  router  AGENTS  [unverified, stable]
|   |-- CLAUDE.md  router  CLAUDE  [unverified, stable]
|   |-- ROUTES.md  router  ROUTES  [unverified, stable]
|   |-- SKOGAI.md  router  SKOGAI  [unverified, stable]
|   |-- todo.list  asset
|   `-- todo.md  concept document is missing YAML frontmatter
```

earlier versions was "frontmatter+json schemas+xml tags" and whatever else we tried out.
then we looked at pydantic types and similar solutions
and now lastly "open knowledge format" seems to be broad enough to actually fill the role ive been looking for

answers;
1. not sure what you mean
2. git my friend! maybe not what one normally use to describe or explain what git is - but understanding what a git diff/patch actually is or what git apply really means deep down is awesome :).
3. technically both i suppose? in the same way that @.git/refs/heads/master or `git branch --verbose` might be called both "HEAD", "latest master" or a commit (this is way simplified but you maybe get my point anyway :))

# claude

Yes to both, and together with OKF they shrink the design considerably.

## Discriminated union

It makes sense, and OKF already provides the mechanics: the `type` frontmatter key is the discriminator. Your `okn list` output is the union printed one node at a time:

- `router` and `asset` are cases.
- `todo.md` with no frontmatter is an untagged value, which is a type error.

OKF leaves `type` as a free-form string, so the union is open. The part skogai adds is **closing it**: dash defines the cases, and a tag that dash does not define is an error. A dot is then a tree of nodes where every node is exactly one case, and "strict types" means every node has a tag, the tag is a known case, and the node satisfies that case.

## The term for base → global → local

The usual names are **layered** or **cascading** configuration, or **overlay**. Functionally it is a fold: `resolve = fold(merge, [base, global, local])`, where the later layer wins.

That is what I was reaching for with "its own sources", and it is different from parent/peer. Layers are ordered inputs to one pure function. No layer knows about the others, so nothing inherits.

In your git terms: each layer is a patch, and the resolved state is the base with the patches applied in order.

## Your answers

1. **Source or derived, restated.** Are there files in a `.skogai` that are generated from other files and never edited by hand? Your todo item `decisions/*.md → DECISIONS.md` would be one. If so, a type should say so, so that `check` can regenerate the file and compare.
2. **Git as the immutability model.** Agreed, and it removes my question. Content is immutable, a change is a patch, and history is the append-only log. "Maintained" memory is then fine, and mutability is not something a type needs to declare. It also defines the CLI: `plan` produces a patch, `apply` applies it, and an empty patch is the idempotent case.
3. **Both a ref and a commit.** A dot names dash by ref, and the ref resolves to a commit at the moment of use. `check` should report the resolved commit, so a result can be reproduced.

## What this means for the CLI

`openknowledge` already has `list`, `validate`, `check` and `ast`, so skogai should not rebuild them. What remains for skogai:

1. **The closed union.** Each case is defined in dash as an OKF page, so types are written in the format they describe.
2. **The fold.** Resolving base → global → local.
3. **`plan` and `apply`.** Patches over a dot.

## Next decision

What does one case definition have to state? My proposal is the minimum: the tag, the required frontmatter fields with their types, and where in the layout the case may appear. Should I draft `router` that way as the first one, since it is the only case already in use?

