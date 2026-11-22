---
name: resume-project
description: Pick up a piece of work in a fresh session from its written state instead of reopening an old session. Works in any project. Use when the user says "resume <project>", "pick up <project>", "continue the <project> work", "where are we on <project>", or names a piece of work to continue at the start of a session. The argument is the name of the work or a few words of it.
---

# Resume a piece of work in a fresh session

A fresh session that reads the written state starts with full detail; a
reopened months-old session starts with whatever survived its compactions.

## Where the state lives

- **Status**: `PROJECTS.md` in the project root (the directory the session was
  started in). One entry per piece of work: a bold title, the name of its
  note, a `Where:` line, a `Next:` line and `- [ ]` items.
- **Context to continue**: the note the entry names, `project_<name>.md`, in
  the `Projects/` directory in the project root.
- If the project's own instructions name different places, use those.

The `save-project` skill writes both.

## First: is this a fresh session?

A skill cannot clear the context or start a session; it runs in the session
it is typed in. So check before anything else.

Look at the conversation so far. It is fresh when nothing came before this
request except session start-up (instructions, memory, `/skills` or similar
housekeeping).

- **Fresh:** go on to the steps.
- **Not fresh, and the user only asked where things stand** ("where are we on
  X", "what is left on X", "status of X"): the check does not apply. Go on
  to the steps and stop after step 5; do not continue the work in this
  session. A bare `/resume-project <name>` or `/new-project <name>`, or any
  request to resume, pick up, continue or start the work, is not a
  status-only question.
- **Not fresh, anything else** (earlier work, questions or file changes are
  in this session): do not search for or read the work. Tell the user, in a
  line or two, to start a fresh session first, by running `/new` (or by
  starting `opencode` again), and then to type `/resume-project <name>`
  there.
  If this session has unsaved work, say that `/save-project` should be run
  before clearing. Then stop.

If the user asks to continue the work after a status report given in a session
that is not fresh, give that same "start a fresh session first" answer.

## Steps

1. **Find the work.** Search `PROJECTS.md` for the name the user gave, matching the
   title or the note file name loosely:
   ```
   grep -n -i "<words>" PROJECTS.md
   ```
   - One exact match: use it. A match is exact when the name the user gave is
     the entry's whole title or its note name (`project_<name>.md`, with or
     without the `project_` prefix and `.md`), ignoring case.
   - One loose match (the words appear only as part of a title or note
     name): do not resume yet. Show the entry's title and ask the user whether
     that is the work they mean or whether this is new work. Go on to step 2
     only after they confirm; if it is new work, say so and start normally.
   - Several: list them and ask which.
   - None, or no `PROJECTS.md`: look for a matching `project_*.md` note in
     `Projects/`, including any `Projects/archive/` sub-directory. Say what
     was found. If it is new work, say so and start normally.

   An entry with nothing outstanding is resumed like any other. A project is
   never finished: report that nothing is outstanding and take up whatever
   the user asks for next.

2. **Read its state**, and only its state:
   - the whole `PROJECTS.md` entry;
   - the note the entry names;
   - any plan or contract document the note names.
   Do not read other pieces of work's notes or the whole knowledge base.

3. **Check the state against reality.** The written state can be behind:
   - `svn status` and `svn log -l 5`, or `git status` and `git log -5`, in
     the working copies the work touches: is anything uncommitted, and did
     commits land after the note was written?
   - For an item about a deploy, compare the revision in the entry with the
     deployed revision the project records, if it records one.
   - Read-only checks only. Do not restart, deploy or change anything here.

4. **Report to the user**, briefly:
   - where the work stands;
   - what is outstanding, marking any item step 3 shows is already done or
     no longer applies;
   - the next step from the `Next:` line;
   - anything that needs their decision.

5. **Correct `PROJECTS.md`** for anything step 3 proved stale (delete items that are done, fix the `Where:` line), and tell the user what was corrected. Never
   delete the entry itself or its note, even when no items are left.

6. **Then do what the user asked.** If they only asked where things stand, stop
   after the report. If they asked to continue, carry on with the next step,
   following the project's own working instructions and using the skill that
   covers a step when one exists.

## When the work is done or paused

Run the `save-project` skill so the state is written back before the session ends.
