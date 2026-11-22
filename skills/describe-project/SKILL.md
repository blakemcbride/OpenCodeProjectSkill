---
name: describe-project
description: Give the detail of one named piece of work from its written records - its PROJECTS.md entry and its project_<name>.md note - changing nothing. Works in any project. Use when the user types "/describe-project <name>", or says "describe project <name>", "describe the <name> project", "tell me about the <name> project" or "show me the <name> project". The argument is the name of the work or a few words of it.
---

# Describe a project

Read-only. This skill changes no file, runs no build, test, restart or
deploy, and does not need a fresh session. It reports what is written down;
it does not check the records against version control or deployed revisions
and does not correct them (`/resume-project` does that).

## Where the records live

- `PROJECTS.md` in the project root (the directory the session was started
  in): one entry per piece of work, from its bold title line down to the
  line before the next bold title or `#` heading.
- `project_<name>.md` in the `Projects/` directory in the project root,
  possibly under `Projects/archive/`.
- If the project's own instructions name different places, use those.

## Steps

1. **Get the name.** If the user gave none, ask for it and suggest
   `/list-projects`.

2. **Find the project.** Search `PROJECTS.md` titles and note names for the
   name, ignoring case:
   ```
   grep -n -i "<words>" PROJECTS.md
   ```
   - One match, exact or loose: use it. Nothing is changed, so no
     confirmation is needed; the report names the project it found.
   - Several: list their names and ask which.
   - None: look for a matching `project_*.md` note in `Projects/`,
     including `Projects/archive/`. If one is found, describe it from the note and
     say it has no `PROJECTS.md` entry. If nothing is found, say so, suggest
     `/list-projects`, and stop.

3. **Read the entry and the note**, and only those. Do not read plans or
   other documents the note names; give their paths instead.

4. **Describe it**, in this order:
   - the title, its name for `/resume-project`, and the `PROJECTS.md`
     section it is under;
   - `Where:` and `Next:`, as written;
   - every outstanding item, as written;
   - from the note, in a few lines each and only where the note has them:
     what the work is, the decisions made and why, the design and the files
     that matter, the traps, and anything agreed but not yet done;
   - the paths of the note and of any plan or document it names.

   Report what the records say. Add no recommendations, and do not start or
   continue the work.
