---
name: split-project
description: Split one recorded piece of work into two - a new PROJECTS.md entry and project_<name>.md note are created, and the outstanding items and note content that belong to the new project move to it - after showing the plan and getting the user's confirmation. Works in any project. Use ONLY when the user's own current message asks for it ("/split-project <name> into <new name>", "split project <name>", "split the <name> project", "split <part> out of the <name> project").
---

# Split one project into two

A piece of work sometimes grows into two. This takes part of one project
(the original) and makes a new project of it. The outstanding items and the
parts of the note that belong to the new project move to a new entry and a
new note. The original keeps its name and everything else. Nothing is
dropped: every item and every part of the note ends up in one project or in
both.

It changes records only. It never touches application code and never
commits, deploys or restarts anything. It does not need a fresh session.

## Where the records live

- `PROJECTS.md` in the project root (the directory the session was started
  in): one entry per piece of work, from its bold title line down to the
  line before the next bold title or `#` heading.
- `project_<name>.md` in the `Projects/` directory in the project root.
- If the project's own instructions name different places, use those.

## Steps

1. **Get the name of the original.** If the user gave none, ask for it and
   suggest `/list-projects`. Split one project into two per run.

2. **Find the project** in `PROJECTS.md` and among the `project_*.md` notes
   in `Projects/`, ignoring case.
   - One exact match (the name is the entry's whole title or its note name):
     use it.
   - One loose match: show the entry's title and ask whether that is the
     project meant. Go on only after a yes.
   - Several matches: list them and ask which. Do not guess.
   - Found only under `Projects/archive/`: say it must be brought back with
     `/unarchive-project` first, and stop.
   - No match: say so, suggest `/list-projects`, and stop.

3. **Read its entry and its note**, and only those.

4. **Settle what moves and the new name.** If the user has not said which
   part becomes the new project, show the entry's items, numbered, and the
   note's headings, and ask which go to the new project. If the user gave no
   name for it, propose a title and a note name, `project_<new-name>.md`.

5. **Check the new name for a collision:**
   ```
   grep -n -i "<new name words>" PROJECTS.md
   ls Projects Projects/archive | grep -i "<new name words>"
   ```
   It is a collision when the new title or note name equals an existing
   entry's title or note name, when one contains the other (the original's
   included), or when a note of that name already exists, including under
   `archive/`. On a collision, choose or ask for a name that neither matches
   nor is contained in an existing one.

6. **Show the plan:**
   - the new project's title and note name;
   - the items that move, and the items that stay;
   - the parts of the note that move, the parts that stay, and the parts
     both projects need, which are copied to both;
   - the `Where:` and `Next:` lines of each entry as they will read.

7. **Ask the user to confirm**, in one question. The yes must come after
   step 6. Anything other than a clear yes: change nothing and stop.

8. **Write the new project first:**
   - The new note, `Projects/project_<new-name>.md`: the title as its
     heading, a line saying it was split from the original and naming the
     original's note, then the parts that move and the parts both need, as
     written. Never overwrite an existing file.
   - The new entry in `PROJECTS.md`, directly after the original's entry and
     so under the same section: the title and note name, a `Where:` line, a
     `Next:` line with its single next step, and the items that move.

9. **Then take the moved parts out of the original**, only after step 8 has
   succeeded:
   - Remove the moved items from the original's entry and make its `Where:`
     and `Next:` lines true for what is left. If no items are left, set
     `Next:` to `Nothing outstanding.` Keep the entry.
   - Remove the moved parts from the original's note, keep the parts both
     need, and add a line naming the new project's note.

10. **Report**, briefly: the two projects and the name to use with
    `/resume-project` for each, the items each now has, and anything that
    was copied to both.
