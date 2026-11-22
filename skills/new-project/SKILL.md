---
name: new-project
description: Alias for the resume-project skill, for use at the start of a fresh session. Use when the user types "/new-project <name>" or says "new project <name>". The argument is the name of the work or a few words of it.
---

# new-project

This skill is an alias. It has no steps of its own.

Invoke the `resume-project` skill (call the `skill` tool with the id
`resume-project`) with the same argument the user gave and follow it exactly,
including its fresh-session check and its checks for an exact match, a loose
match and no match. If the `skill` tool cannot load it, read
`~/.config/opencode/skills/resume-project/SKILL.md` and follow that.

Do not copy steps from `resume-project` into this file; a second copy
drifts out of agreement with the first.
