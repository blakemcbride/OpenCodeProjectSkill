---
name: save-project
description: Save where a project stands right now, so nothing is lost and a fresh session can pick it up later. It can be run at any time, including in the middle of work; it saves the current state and the work continues. Works in any project. Use when the user types "/save-project", or says "save project", "save where we are", "save the project", "wrap up", "let's stop here" or "end project", or asks to end or hand off the session. Offer it at a natural stopping point or before a long session is compacted.
---

# Save the current state of a project

The aim: where the project stands right now is written down, so that
nothing is lost if this session ends or its context is compacted, and a
fresh session can pick the work up with full detail.

A save is a checkpoint, not an ending:

- It can be run at any time, including in the middle of work. After the
  save, carry on with what was being done, unless the user said they are stopping.
- A project is never finished. More corrections and enhancements are always
  possible, so a save never marks a project as done or closed, and never
  treats it as if it were.
- It never deletes a project: not its `PROJECTS.md` entry and not its note.
  Only the `delete-project` skill deletes a project, and only when the user
  asks for it.

Saving changes no application code, commits nothing, deploys nothing and
restarts nothing. It does not stop or wait for work that is running.

## Where the state lives

- **Status**: `PROJECTS.md` in the project root (the directory the session was
  started in). One entry per project. Create the file if the project does
  not have one yet.
- **Context to continue**: one note per project, `project_<name>.md`, in the
  `Projects/` directory in the project root. Create the directory if the
  project does not have one yet. The `PROJECTS.md` entry names its note.
  Notes are kept in the project, not in OpenCode's own data directory, so
  that nothing OpenCode stores or clears can remove them.
- If the project's own instructions name different places for these, use
  those.

A `PROJECTS.md` entry looks like this:

```
**Short title of the work** — `project_<name>.md`
Where: what is committed and what is deployed where
Next: the single next step

- [ ] One outstanding thing, understandable with no context, saying who does it
- [ ] Another
```

## Steps

1. **Say where the work stands**, in a few lines: what has been built or
   changed so far in this session, and what was being done at the moment of
   the save.

2. **Note what is in flight.** Record it; do not stop it, wait for it or
   clean it up as part of the save.
   - Uncommitted changes: `svn status` or `git status` in each working copy
     or repository the session touched. List what is uncommitted.
   - Work half done: an edit started but not completed, a test not yet run,
     a failure not yet understood.
   - Any agent or background process still running, and what it is doing.
   - Debug logging added during the session that is still in the code.

3. **Update `PROJECTS.md`.** Find the project's entry (add one if it is new)
   and make it true as of now:
   - Delete items that have been done.
   - Add each thing still outstanding as its own item, including everything
     step 2 found: a half-done edit, a restart and test, a live test, a
     deploy, a decision, an uncommitted change, debug logging to remove.
   - Set the `Where:` line.
   - Set the `Next:` line to the single next step. In the middle of work
     that is the step to take up again.
   - If nothing is outstanding, keep the entry with no items and set `Next:`
     to `Nothing outstanding.` Do not call the project finished, and do not
     delete the entry or its note.

   **Before adding an entry for a new project, check its name for a
   collision.** Pick the title and the note name, then search for them:
   ```
   grep -n -i "<name words>" PROJECTS.md
   ls Projects Projects/archive | grep -i "<name words>"
   ```
   It is a collision when the new title or note name equals an existing
   entry's title or note name, when one contains the other, or when a
   `project_<name>.md` note of that name already exists, including under
   `archive/`. On a collision, do not write yet: show the user the existing
   entry or note and ask whether this session's work is that same project
   (then update that entry and note) or a new one (then choose a name that
   neither matches nor is contained in an existing one, and tell them the
   name). If it is the same project and its note is under `archive/`, it
   has to be brought back with `/unarchive-project <name>` before the save
   goes on. Never overwrite an existing note that belongs to a different
   project.

4. **Write down what a fresh session cannot rediscover from the code**, in
   the project's note (create it for a new project and name it in the
   `PROJECTS.md` entry). Keep it to what is needed to continue:
   - decisions the user made and why, including options they rejected;
   - the design in a few lines, and the files that matter;
   - traps found along the way;
   - anything agreed but not yet done;
   - in the middle of work, the approach being taken and what has been
     tried and ruled out.
   State how things are now. No session narrative, no status (that is in
   `PROJECTS.md`), nothing the code or the commit log already shows. Do not add
   the note to `AGENTS.md`.

5. **Put lasting knowledge where it belongs**, for what has been learned so
   far.
   - A rule the user gave, or a correction to how the agent should work: an
     entry in `AGENTS.md`, or in the global `~/.config/opencode/AGENTS.md`
     when it applies to every project.
   - How the code works, a pattern, a pitfall: the project's knowledge base
     or developer documentation, if it has one, following that project's
     rules for updating it.
   - Behavior a manual describes: update the manual, if the project has one.

6. **Report to the user**, briefly:
   - that the state is saved, and the name to use with
     `/resume-project <name>`;
   - what is outstanding (the `PROJECTS.md` items);
   - what is uncommitted, and anything still running.

7. **Continue or stop.**
   - If the user was in the middle of work and did not say they are stopping,
     carry on with it.
   - If they said they are stopping ("wrap up", "let's stop here", ending or
     handing off the session), say that the session can be closed, and name
     anything still running that closing it would cut off.

## Do not

- Commit, push, deploy or restart anything as part of a save. If
  uncommitted work exists, list it; the user decides.
- Stop, wait for or cancel running work, or remove debug logging, because
  of a save. Record it instead.
- Leave status in a memory file or in `AGENTS.md`.
- Delete a `PROJECTS.md` entry or a project note, move a note to `archive/`,
  or describe a project as finished or closed.
