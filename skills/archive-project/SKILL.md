---
name: archive-project
description: Set a named piece of work aside without deleting it - its note moves to Projects/archive/ and its PROJECTS.md entry is kept inside the note, so unarchive-project can bring both back. Works in any project. Use ONLY when the user's own current message asks for it ("/archive-project <name>", "archive project <name>", "archive the <name> project", "shelve the <name> project"). Never use it because nothing is outstanding on a project; such a project keeps its entry and note where they are.
---

# Archive a project

This sets a piece of work aside. Its note moves to `Projects/archive/`, and
its `PROJECTS.md` entry is taken out of `PROJECTS.md` and kept, word for
word, inside the note. Nothing is lost, and `/unarchive-project <name>`
puts both back.

Archiving is not finishing. A project is never finished; an archived
project is one the user does not want in the working list for now.

It changes records only. It never touches application code and never
commits, deploys or restarts anything. It does not need a fresh session.

## Where the records live

- `PROJECTS.md` in the project root (the directory the session was started
  in): one entry per piece of work, from its bold title line down to the
  line before the next bold title or `#` heading.
- `project_<name>.md` in the `Projects/` directory in the project root.
- Archived notes: `Projects/archive/`.
- If the project's own instructions name different places, use those.

## Steps

1. **Get the name.** If the user gave none, ask for it and suggest
   `/list-projects`. Archive one project per run.

2. **Find the project.** Search `PROJECTS.md` titles and note names, and the
   `project_*.md` files in `Projects/`, for the name, ignoring case.
   - One exact match (the name is the entry's whole title or its note name):
     use it.
   - One loose match: show the entry's title and ask whether that is the
     project meant. Go on only after a yes.
   - Several matches: list them and ask which. Do not guess.
   - Found only under `Projects/archive/`: say it is already archived and
     stop.
   - No match: say so, suggest `/list-projects`, and stop.

3. **Check the way is clear.** If `Projects/archive/` already holds a note
   of the same name, change nothing, say so, and stop; the user can rename
   one of them with `/rename-project`.

4. **Keep the entry inside the note.** Append this to the end of the note,
   with the entry copied word for word, items included:
   ```
   ## Archived PROJECTS.md entry

   Section: <the # heading the entry was under, or "none">

   <the whole entry>
   ```
   If the project has a note but no `PROJECTS.md` entry, skip this step. If
   it has an entry but no note, create the note with the entry's title as
   its heading and this section in it.

5. **Move the note** to `Projects/archive/`, creating the directory if it
   does not exist, with literal full paths:
   `mv -n "/full/path/Projects/project_<name>.md" "/full/path/Projects/archive/project_<name>.md"`.
   If the note is under version control, use `git mv` or `svn mv` instead;
   neither commits anything.

6. **Remove the entry from `PROJECTS.md`** with the edit tool, only after
   steps 4 and 5 have succeeded, leaving one blank line between its
   neighbours. Do not delete `PROJECTS.md` itself or a section heading, even
   if the section is now empty. Remove any line in `AGENTS.md` that points
   at the note.

7. **Report**, briefly: the project archived, the new path of its note, how
   many outstanding items went with it, and that
   `/unarchive-project <name>` brings it back. If the entry listed
   outstanding or uncommitted work, say that archiving does not undo or
   finish that work, it only takes it out of the working list.
