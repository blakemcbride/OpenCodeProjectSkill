---
name: status-projects
description: Show one line per recorded piece of work - its name, its next step and how many items are outstanding - from the project's PROJECTS.md, changing nothing. Works in any project. Use when the user types "/status-projects", or says "status of the projects", "status of all projects", "what is outstanding across the projects", "what should I work on" or "which project next". An optional argument narrows it to entries matching those words. For names only use list-projects; for the detail of one project use describe-project; for the checked status of one project use resume-project.
---

# Status of all the projects

Read-only. This skill changes no file, runs no build, test, restart or
deploy, and does not need a fresh session. It reports what `PROJECTS.md`
says; it does not check the entries against version control and does not
correct stale ones (`/resume-project` does that, one project at a time).

## Where the status comes from

`PROJECTS.md` in the project root (the directory the session was started
in). Each piece of work is one entry: a bold title line naming its note,
`project_<name>.md`, a `Where:` line, a `Next:` line and `- [ ]` items. If
the project's own instructions name a different file, use that.

## Steps

1. **Read `PROJECTS.md`**, and only that file. Do not read the notes. If
   there is no `PROJECTS.md`, say the project has none and stop.

2. **If the user gave words to narrow it**, keep only the entries whose
   title or note name contains them, ignoring case.

3. **Show one line per project**, under each of the file's own section
   headings (skip a heading with no entries):
   ```
   <name> (<count>): <the Next: line, as written>
   ```
   The name is the note name without `project_` and `.md`; for an entry
   that names no note, use its title. The count is the number of `- [ ]`
   items in the entry. Shorten a `Next:` line that runs past one line and
   end it with `...`.

   Keep the order of the file. End with one line giving the number of
   projects and the total of outstanding items.

   Do not show `Where:` lines, the items themselves or archived projects.
   The detail of a project comes from `/describe-project <name>`.

4. **If the user asked what to work on**, add one line naming the projects
   whose `Next:` line is something the agent or the user can do now, as
   against one that waits on someone else or says `Nothing outstanding.`
   Base it only on what the entries say. Otherwise add no commentary or
   recommendations, and do not start or continue any work.
