---
name: merge-project
description: Merge one recorded piece of work into another - its outstanding items and the whole content of its note go into the other project's PROJECTS.md entry and note, then its own entry and note are removed - after showing the plan and getting the user's confirmation. Works in any project. Use ONLY when the user's own current message asks for it ("/merge-project <name> into <other name>", "merge project <name> into <other name>", "merge the <name> project into <other name>", "combine the <name> and <other name> projects").
---

# Merge one project into another

Two entries sometimes turn out to be one piece of work. This folds one
project (the source) into another (the target). Everything the source held
ends up in the target: its outstanding items in the target's entry, and the
content of its note in the target's note. Then the source's own entry and
note are removed. No content is dropped.

It changes records only. It never touches application code and never
commits, deploys or restarts anything. It does not need a fresh session.

## Where the records live

- `PROJECTS.md` in the project root (the directory the session was started
  in): one entry per piece of work, from its bold title line down to the
  line before the next bold title or `#` heading.
- `project_<name>.md` in the `Projects/` directory in the project root.
- If the project's own instructions name different places, use those.

## Steps

1. **Get both names and the direction.** The request has the form
   `<source> into <target>`. Ask for whichever is missing, and suggest
   `/list-projects`. If the user named two projects without saying which is
   kept ("combine A and B"), ask which name is kept. Merge one pair per run.

2. **Find both projects** in `PROJECTS.md` and among the `project_*.md`
   notes in `Projects/`, ignoring case.
   - Each must be one match. For a loose match, show the entry's title and
     ask whether that is the project meant. For several matches, list them
     and ask which. For no match, say so and stop.
   - If the two names find the same project, say so and stop.
   - If either is found only under `Projects/archive/`, say it must be
     brought back with `/unarchive-project` first, and stop.

3. **Read both entries and both notes**, and only those.

4. **Show the plan:**
   - the title and note that are kept, and the title and note that go;
   - the items that will be added to the target's entry;
   - the target's `Where:` and `Next:` lines as they will read;
   - every other file that refers to the source's note, found with
     `grep -rn "<source note name without .md>"` over `Projects/`, `AGENTS.md`
     and `PROJECTS.md`.

5. **Ask the user to confirm**, in one question, saying that the source's
   own entry and note are removed after their content has been moved. The
   names in the command are not the confirmation; the yes must come after
   step 4. Anything other than a clear yes: change nothing and stop.

6. **Merge the entries** in `PROJECTS.md` with the edit tool:
   - Add each of the source's `- [ ]` items to the target's entry, as
     written. Leave out an item that says the same thing as one already
     there.
   - Make the target's `Where:` line cover both.
   - Keep the target's `Next:` line. If the source's `Next:` line names a
     different step and is not `Nothing outstanding.`, add it as an item.
   - Keep the target's title and note name.

7. **Merge the notes.** Append the whole content of the source's note to the
   target's note under a new heading, lowering its own headings one level so
   they sit beneath it:
   ```
   ## Merged from <source title>
   ```
   Copy it; do not summarize it or leave parts out. Where the two notes
   contradict each other, keep both and say so in the report.

8. **Remove the source**, only after steps 6 and 7 have succeeded:
   - Remove its entry from `PROJECTS.md`, leaving one blank line between its
     neighbours. Do not delete a section heading, even if the section is now
     empty.
   - Delete its note with its literal full path:
     `rm -f "/full/literal/path/project_<source>.md"`. No variables, no
     wildcards, no command substitution in that command.
   - In the other notes in `Projects/` and in `AGENTS.md`, change the
     source's note name to the target's. Drop an `AGENTS.md` line that would
     now duplicate another.
   - Leave other files that mention the source alone, and list them in the
     report.

9. **Report**, briefly: the project kept and the name to use with
   `/resume-project <name>`, the items added, the note content added, the
   entry and note removed, any contradiction left for the user to settle,
   and any references left behind.
