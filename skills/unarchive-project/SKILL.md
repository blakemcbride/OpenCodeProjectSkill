---
name: unarchive-project
description: Bring an archived piece of work back into the working list - its note moves from Projects/archive/ back to Projects/ and its PROJECTS.md entry is restored from the copy kept in the note. Works in any project. Use when the user types "/unarchive-project <name>", or says "unarchive project <name>", "unarchive the <name> project", "restore the <name> project from the archive" or "bring back the <name> project". With no name it lists the archived projects.
---

# Unarchive a project

This undoes `/archive-project`. The note moves from `Projects/archive/`
back to `Projects/`, and the `PROJECTS.md` entry kept inside the note goes
back into `PROJECTS.md`.

It changes records only. It never touches application code and never
commits, deploys or restarts anything. It does not need a fresh session,
and it does not resume the work; `/resume-project <name>` in a fresh session
does that.

## Where the records live

- `PROJECTS.md` in the project root (the directory the session was started
  in): one entry per piece of work.
- `project_<name>.md` in the `Projects/` directory in the project root.
- Archived notes: `Projects/archive/`.
- If the project's own instructions name different places, use those.

## Steps

1. **Get the name.** If the user gave none, list the archived projects (the
   `project_*.md` files in `Projects/archive/`, shown without `project_` and
   `.md`), ask which, and stop until they answer. If there is no
   `Projects/archive/` or it holds no notes, say nothing is archived and
   stop. Unarchive one project per run.

2. **Find the note** in `Projects/archive/` by the name, ignoring case.
   - One exact match (the name is the whole note name, or the whole title in
     the entry kept in the note): use it.
   - One loose match: show its name and ask whether that is the project
     meant. Go on only after a yes.
   - Several matches: list them and ask which. Do not guess.
   - No match: say so, list what is archived, and stop.

3. **Check the way is clear.** If `Projects/` already holds a note of the
   same name, or `PROJECTS.md` already has an entry with the same title or
   note name, change nothing, show the user what is in the way, and stop;
   the user can rename one of them with `/rename-project`.

4. **Move the note** back to `Projects/` with literal full paths:
   `mv -n "/full/path/Projects/archive/project_<name>.md" "/full/path/Projects/project_<name>.md"`.
   If the note is under version control, use `git mv` or `svn mv` instead;
   neither commits anything.

5. **Restore the entry.**
   - If the note has an `## Archived PROJECTS.md entry` section, put the
     entry it holds back into `PROJECTS.md`, word for word, under the
     section named on its `Section:` line. If that section no longer exists,
     or the line says `none`, put it after the last entry in the file. Then
     remove the whole `## Archived PROJECTS.md entry` section from the note.
   - If the note has no such section, add a new entry: the title from the
     note's first heading, the note name, `Where: restored from the archive;
     its status was not recorded`, and `Next: Review the note and set the
     next step.`
   - Create `PROJECTS.md` if the project has none.

6. **Report**, briefly: the project restored, the path of its note, its
   `Next:` line and number of outstanding items, and that the entry is as it
   was when archived and may be out of date; `/resume-project <name>` in a
   fresh session checks it against version control.
