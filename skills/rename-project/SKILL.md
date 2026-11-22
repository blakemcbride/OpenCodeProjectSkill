---
name: rename-project
description: Rename a piece of work in the project's records - the title of its PROJECTS.md entry and its project_<name>.md note - and fix the references to it. Works in any project. Use ONLY when the user's own current message asks for it ("/rename-project <name> to <new name>", "rename project <name> to <new name>", "rename the <name> project to <new name>").
---

# Rename a project

This gives a piece of work a new name: the bold title of its `PROJECTS.md`
entry and the file name of its note. Nothing else about the project changes.

It changes records only. It never touches application code and never
commits, deploys or restarts anything. It does not need a fresh session.

## Where the records live

- `PROJECTS.md` in the project root (the directory the session was started
  in): one entry per piece of work, from its bold title line down to the
  line before the next bold title or `#` heading.
- `project_<name>.md` in the `Projects/` directory in the project root,
  possibly under `Projects/archive/`.
- If the project's own instructions name different places, use those.

## Steps

1. **Get both names.** The request has the form `<name> to <new name>`. Ask
   for whichever is missing, and suggest `/list-projects` for the old one.
   Rename one project per run.

2. **Find the project.** Search `PROJECTS.md` titles and note names, and the
   `project_*.md` files in `Projects/` including `Projects/archive/`, for
   the old name, ignoring case.
   - One exact match (the name is the entry's whole title or its note name):
     use it.
   - One loose match: show the entry's title and ask whether that is the
     project meant. Go on only after a yes.
   - Several matches: list them and ask which. Do not guess.
   - No match: say so, suggest `/list-projects`, and stop.

3. **Settle the new title and note name.** The title is the new name as the
   user gave it. The note name is `project_<new-name>.md`, with the new name
   in lower case and its words joined by hyphens. If the user gave only a
   note-style name, keep the old title's wording where it still fits.

4. **Check the new name for a collision**, leaving the project being renamed
   out of the comparison:
   ```
   grep -n -i "<new name words>" PROJECTS.md
   ls Projects Projects/archive | grep -i "<new name words>"
   ```
   It is a collision when the new title or note name equals another entry's
   title or note name, when one contains the other, or when a note of that
   name already exists, including under `archive/`. On a collision change
   nothing: show the user the existing entry or note and ask for a different
   name.

5. **Rename**, in this order:
   - Move the note, keeping it in the directory it is in, with literal full
     paths: `mv -n "/full/path/project_<old>.md" "/full/path/project_<new>.md"`.
     If the note is under version control, use `git mv` or `svn mv` instead;
     neither commits anything.
   - In `PROJECTS.md`, change the entry's bold title and the note name on
     its title line with the edit tool. Leave the rest of the entry as it is.
   - If the note's first heading is the old title, change it to the new one.
   - Change the old note name to the new one wherever it appears in
     `PROJECTS.md`, in the other notes in `Projects/`, and in `AGENTS.md`.
     Find them with `grep -rn "project_<old>"` over those places.
   - Leave other files that mention the old name alone, and list them in the
     report so the user can decide.

   An archived project has no `PROJECTS.md` entry; rename its note, and the
   title in the entry kept inside the note.

6. **Report**, briefly: the old and new title, the old and new note name,
   the references changed, any references left behind, and the name to use
   with `/resume-project <new name>`. If the records are under version
   control, say the rename is uncommitted.
