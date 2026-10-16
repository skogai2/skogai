---
type: type
title: rule
description: a constraint that can be checked, enforcing a decision.
fields: [type, title, applies_to]
owns: [type/rule/<name>.md]
watches: [<applies_to>]
---

# rule

a rule is a decision made checkable.

- **applies_to**: the paths the rule constrains. the rule watches them and is re-checked when they change.
- **from**: optional, the decision it enforces.

a "we do X" that cannot be checked is a decision, not a rule.
