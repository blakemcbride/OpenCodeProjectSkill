---
name: list-projects
description: Briefly list the pieces of work currently recorded in the project's PROJECTS.md, names only, changing nothing. Works in any project. Use when the user types "/list-projects", or says "list projects", "list the projects", "what projects are there", "what projects are open" or "show the projects". An optional argument narrows the list to entries matching those words. For the detail of one project use describe-project.
---

# List the projects

Read-only and brief. This skill changes no file, runs no build, test,
restart or deploy, and does not need a fresh session. It does not correct
stale entries either.

## Where the list comes from

`PROJECTS.md` in the project root (the directory the session was started
in). Each piece of work is one entry whose bold title line names its note,
`project_<name>.md`. If the project's own instructions name a different
file, use that.

## Steps

1. **Read the headings and title lines:**
   ```
   grep -n '^#\|^\*\*' PROJECTS.md
   ```
   If there is no `PROJECTS.md`, say the project has none and stop.

2. **If the user gave words to narrow the list**, keep only the entries whose
   title or note name contains them, ignoring case.

3. **Show the names, and nothing else.** A project's name is its note name
   without `project_` and `.md`; for an entry that names no note, use its
   title. Under each of the file's own section headings (skip a heading with
   no entries), put that section's names on one line, separated by commas.
   End with one line giving the total number of entries.

   Do not show titles, `Where:` or `Next:` lines, item counts, notes without
   an entry, commentary or recommendations. The detail of a project comes
   from `/describe-project <name>`.
