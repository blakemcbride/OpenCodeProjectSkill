---
name: delete-project
description: Delete a named piece of work from the project's records - its PROJECTS.md entry and its project_<name>.md note - after showing what will go and getting the user's confirmation. Works in any project. Use ONLY when the user's own current message asks for it ("/delete-project <name>", "delete project <name>", "delete the <name> project"). Never use it because nothing is outstanding on a project; such a project keeps its entry and note.
---

# Delete a project

This removes the written record of a piece of work: its `PROJECTS.md` entry
and its project note. Unless the project keeps `Projects/` under version
control, the deletion cannot be undone.

It deletes records only. It never touches application code, never reverts,
commits, deploys or restarts anything, and never deletes any other memory
file, plan or document. It does not need a fresh session.

## Where the records live

- `PROJECTS.md` in the project root (the directory the session was started
  in): one entry per piece of work, from its bold title line down to the
  line before the next bold title or `#` heading.
- `project_<name>.md` in the `Projects/` directory in the project root,
  possibly under `Projects/archive/`.
- If the project's own instructions name different places, use those.

## Steps

1. **Get the name.** If the user gave none, ask for it and suggest
   `/list-projects`. Delete one project per run.

2. **Find the project.** Search `PROJECTS.md` titles and note names, and the
   `project_*.md` files in `Projects/` including `Projects/archive/`, for
   the name, ignoring case.
   - Several matches: list them and ask which. Do not guess.
   - No match: say so, suggest `/list-projects`, and stop.
   - One match, exact or loose: go on. Step 4 asks either way.

3. **Show exactly what would be deleted:**
   - the entry's title, its `Where:` and `Next:` lines, and how many
     outstanding items it has (or say there is no `PROJECTS.md` entry);
   - the full path of the note (or say there is no note);
   - every other file that refers to the note, found with
     `grep -rn "<note name without .md>"` over `Projects/`, `AGENTS.md` and
     `PROJECTS.md`;
   - if the entry lists outstanding or uncommitted work, say that deleting
     the record does not undo or finish that work, it only stops tracking it.

4. **Ask the user to confirm**, in one question, saying it cannot be undone.
   The name in the command is not the confirmation; the yes must come after
   step 3. If the note is not already under `Projects/archive/`, offer
   `/archive-project <name>` as the alternative to deleting it: that sets
   the project aside and loses nothing. If the user chooses it, follow the
   `archive-project` skill instead and delete nothing. Anything other than a
   clear yes: change nothing and stop.

5. **Delete**, only what step 3 showed:
   - Remove the entry from `PROJECTS.md` with the edit tool, leaving one
     blank line between its neighbours. Do not delete `PROJECTS.md` itself
     or a section heading, even if the section is now empty.
   - Delete the note with its literal full path:
     `rm -f "/full/literal/path/project_<name>.md"`. No variables, no
     wildcards, no command substitution in that command.
   - Remove any line in `AGENTS.md` that points at the note.
   - Leave other files that mention the note alone, and list them in the
     report so the user can decide.

6. **Report**, briefly: the entry removed, the note deleted, any `AGENTS.md`
   line removed, and any references left behind.
