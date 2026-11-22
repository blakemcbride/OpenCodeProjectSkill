# Project Skills

Six OpenCode skills keep one piece of work to one OpenCode session and
manage the written record of each piece of work:

| Skill | What it does | When to use it |
|---|---|---|
| `/new-project <name>` | Alias for `/resume-project`. | First thing in a fresh session. |
| `/resume-project <name>` | Reads a piece of work's written state and reports where it stands, then continues it. | First thing in a fresh session; a status-only question works in any session. |
| `/save-project` | Saves where the project stands right now, then the work continues. | Any time, including mid-work, and before closing a session. |
| `/list-projects [words]` | Briefly lists the recorded pieces of work, names only. Changes nothing. | Any time. |
| `/describe-project <name>` | Gives the detail of one piece of work from its entry and note. Changes nothing. | Any time. |
| `/delete-project <name>` | Deletes a piece of work's entry and note, after confirmation. | Any time, on an explicit request only. |

Their source is in `skills/<name>/SKILL.md` in this repository, each with a
matching command in `commands/<name>.md`. Installed under
`~/.config/opencode/`, they work in every project. The skill files are the
authority; this document describes them.

## The idea

A session kept open for weeks loses detail every time its context is
compacted. A written state does not. So the state of a project is written
down with `/save-project`, and a fresh session starts by reading it back
(`/resume-project` or `/new-project`).

This also saves tokens. A long or reopened session carries its whole
history, and that history is sent to the model again on every turn. A fresh
session that reads a project's entry and note starts with only the few
kilobytes that matter. `/resume-project` reads that one project's state and
nothing else for the same reason.

A project is never finished: more corrections and enhancements are always
possible. No skill marks a project as done or closed. A save is a checkpoint
of where the project stands right now, not an ending.

The normal cycle:

1. Start `opencode` (or run `/new`).
2. Type `/resume-project <name>` or `/new-project <name>`.
3. Do the work. Type `/save-project` whenever a checkpoint is wanted,
   including in the middle of the work; it saves and the work continues.
4. Type `/save-project` before closing the session.
5. Close the session.

## Where the state lives

| What | File | Holds |
|---|---|---|
| Status | `PROJECTS.md` in the project root (the directory the session was started in) | One entry per project. |
| Context | `project_<name>.md` in the `Projects/` directory in the project root | What the next session cannot rediscover from the code. |

A project may also keep older notes that have no `PROJECTS.md` entry in
`Projects/archive/`. The skills search there but never move a note into it
on their own.

If a project's own instructions name different places, the skills use those.

The state has the same format and lives in the same place as the Claude Code
version of these skills, so a project saved under one is resumed under the
other.

A `PROJECTS.md` entry looks like this:

```
**Short title of the work** — `project_<name>.md`
Where: what is committed and what is deployed where
Next: the single next step

- [ ] One outstanding thing, understandable with no context, saying who does it
- [ ] Another
```

### Nothing is deleted automatically

Both the entries and the notes are kept in the project itself, not in
OpenCode's own data directory, so they travel with the project: they are
backed up with it, can be put under version control, and nothing OpenCode
stores or removes on its own can take them.

A project's entry and note are removed only by `/delete-project`, after
confirmation. `/save-project` and `/resume-project` never delete an entry or
a note. A project with nothing outstanding keeps its entry, with no items
and `Next: Nothing outstanding.`

Neither file is under version control unless the project puts it there, so a
backup is a separate matter.

## A project's name

There is no registry of names. A piece of work is known by the title of its
`PROJECTS.md` entry and by its note name, `project_<name>.md`. The name is
first created by `/save-project`, which reports it at the end for use with
`/resume-project <name>` next time.

## /resume-project

Triggered by `/resume-project <name>`, "resume <project>", "pick up
<project>", "continue the <project> work", "where are we on <project>", or
naming a piece of work to continue at the start of a session.

### It needs a fresh session

A skill cannot clear the context or start a session; it runs in the session
it is typed in. So the skill first looks at the conversation:

- **Fresh** (nothing before the request except session start-up): it goes on.
- **Not fresh, status-only question** ("where are we on X", "what is left on
  X", "status of X"): the check does not apply. It runs steps 1 to 5, gives
  the report and stops, without continuing the work in that session.
- **Not fresh, anything else** (earlier work, questions or file changes are
  in the session): it does not search or read anything. It says to start a
  fresh session first, with `/new` or a new `opencode`, and to type the
  command there. If the session has unsaved work, it says to run
  `/save-project` before clearing. Then it stops.

A bare `/resume-project <name>` or `/new-project <name>`, or any request to
resume, pick up, continue or start the work, is not a status-only question.
Asking to continue after a mid-session status report gets the same "start a
fresh session first" answer.

### Steps

1. **Find the work.** It searches `PROJECTS.md` for the name given, against
   each entry's title and note name.

   | Result | What it does |
   |---|---|
   | One exact match (the name is the entry's whole title or its note name, ignoring case) | Uses it. |
   | One loose match (the words are only part of a title or note name) | Shows the entry's title and asks whether that is the work meant or whether this is new work. It continues only after a yes. |
   | Several matches | Lists them and asks which. |
   | No match, or no `PROJECTS.md` | Looks for a matching `project_*.md` note in `Projects/`, including `Projects/archive/`, and says what it found. For new work it says so and starts normally. |

   An entry with nothing outstanding is resumed like any other: a project
   is never finished, so it reports that nothing is outstanding and takes
   up whatever is asked next.

   For new work it creates nothing; `/save-project` creates the entry and the
   note at the end.

2. **Read its state, and only its state:** the `PROJECTS.md` entry, the note
   the entry names, and any plan or contract document the note names.

3. **Check the state against reality,** read-only: `svn status` and
   `svn log -l 5` (or `git status` and `git log -5`) in the working copies the
   work touches, and the deployed revision the project records for any
   deploy item. It restarts, deploys and changes nothing.

4. **Report:** where the work stands, what is outstanding (marking anything
   step 3 shows is already done), the next step, and anything that needs a
   decision.

5. **Correct `PROJECTS.md`** where step 3 proved it stale, and say what was
   corrected. It never deletes the entry or the note.

6. **Do what was asked.** For a status question it stops after the report.
   Otherwise it carries on with the next step.

## /new-project

Triggered by `/new-project <name>` or "new project <name>".

It is an alias and has no steps of its own: it loads `/resume-project` with
the same name and follows it. Everything in the section above applies,
including the fresh-session check and the match rules. A name that partly
matches existing work therefore gets the "is this the work you mean?"
question, and a name that matches nothing is treated as new work.

## /save-project

Triggered by `/save-project`, "save project", "save where we are", "save the
project", "wrap up", "let's stop here", "end project", or a request to end
or hand off the session. The agent also offers it at a natural stopping
point or before a long session is compacted. The skills do not produce that
prompt themselves; a project can supply one with an OpenCode plugin.

It saves where the project stands right now. It is a checkpoint, not an
ending:

- It can be run at any time, including in the middle of work. After the
  save the work continues, unless the request was to stop.
- It never marks a project as finished or closed.
- It never deletes a project: not its `PROJECTS.md` entry and not its note,
  and it does not move a note to `archive/`.

It changes no application code and never commits, pushes, deploys or restarts
anything. It does not stop or wait for work that is running. What is in
flight is recorded, not cleaned up.

### Steps

1. **Say where the work stands,** in a few lines: what has been done so far
   in the session and what was being done at the moment of the save.

2. **Note what is in flight,** without stopping or cleaning up any of it:
   uncommitted changes in each working copy the session touched, work half
   done, agents or background processes still running, and debug logging
   still in the code.

3. **Update `PROJECTS.md`.** It finds the project's entry, or adds one, and
   makes it true as of now: done items deleted, each outstanding thing added
   as its own item (including everything step 2 found), the `Where:` and
   `Next:` lines set. In the middle of work, `Next:` is the step to take up
   again. If nothing is outstanding, the entry stays, with no items and
   `Next:` set to `Nothing outstanding.` It creates `PROJECTS.md` and
   `Projects/` if the project has none.

   **Name collision check.** Before adding an entry for a new project, it
   searches `PROJECTS.md` and the `project_*.md` notes in `Projects/`,
   including `Projects/archive/`, for the new title and note name. It is a
   collision when:

   - the new name equals an existing title or note name;
   - one name contains the other; or
   - a note of that name already exists.

   On a collision it writes nothing, shows the existing entry or note, and
   asks whether this is that same work or new work. Same work: it updates
   that entry and note. New work: it chooses a name that neither matches nor
   is contained in an existing one, and says what the name is. It never
   overwrites a note that belongs to different work.

   A name that passes this check cannot be a loose match for another entry in
   `/resume-project`.

4. **Write the project note** (`project_<name>.md`) with what a fresh
   session cannot rediscover from the code: decisions made and why, including
   rejected options; the design in a few lines and the files that matter;
   traps found; anything agreed but not yet done; and, in the middle of
   work, the approach being taken and what has been tried and ruled out. It
   states how things are now, with no session narrative and no status. The
   note is not added to `AGENTS.md`.

5. **Put lasting knowledge where it belongs:** a rule or correction goes in
   `AGENTS.md`, or in the global `~/.config/opencode/AGENTS.md` when it
   applies to every project; how the code works goes in
   the project's knowledge base; behavior a manual describes goes in the
   manual.

6. **Report:** that the state is saved, the name to use with
   `/resume-project <name>`, what is outstanding, what is uncommitted, and
   anything still running.

7. **Continue or stop.** In the middle of work it carries on with the work.
   If the request was to stop ("wrap up", "let's stop here", ending the
   session), it says the session can be closed and names anything still
   running that closing would cut off.

## /list-projects

Triggered by `/list-projects`, "list projects", "list the projects", "what
projects are there", "what projects are open" or "show the projects".

It is read-only and brief: it changes no file, does not correct stale
entries, and does not need a fresh session.

### Steps

1. **Read the headings and title lines** of `PROJECTS.md`. If the project
   has no `PROJECTS.md`, it says so and stops.

2. **Narrow the list** if words were given: only entries whose title or note
   name contains them, ignoring case.

3. **Show the names, and nothing else.** A project's name is its note name
   without `project_` and `.md` (its title, for an entry that names no
   note). Each section of the file gets one line of names separated by
   commas, and the last line gives the total. It shows no titles, `Where:`
   or `Next:` lines, item counts or commentary; that detail comes from
   `/describe-project <name>`.

## /describe-project

Triggered by `/describe-project <name>`, "describe project <name>",
"describe the <name> project", "tell me about the <name> project" or "show
me the <name> project".

It is read-only and does not need a fresh session. It reports what is
written down: it does not check the records against version control or
deployed revisions and does not correct them, which is what a status
question to `/resume-project` does.

### Steps

1. **Get the name.** With none given it asks, and suggests `/list-projects`.

2. **Find the project** in `PROJECTS.md`, by title or note name. One match,
   exact or loose: it uses it without asking, since nothing is changed, and
   names the project it found. Several: it lists their names and asks which.
   None: it looks for a matching `project_*.md` note in `Projects/`,
   including `Projects/archive/`, and describes the work from the note,
   saying it has no `PROJECTS.md` entry. Nothing found: it says so and stops.

3. **Read the entry and the note,** and only those. Plans and other
   documents the note names are given as paths, not read.

4. **Describe it:** the title, its name for `/resume-project` and its
   section; the `Where:` and `Next:` lines; every outstanding item; from the
   note, what the work is, the decisions made and why, the design and the
   files that matter, the traps, and anything agreed but not yet done; and
   the paths of the note and of any document it names. It adds no
   recommendations and does not start or continue the work.

## /delete-project

Triggered only by an explicit request: `/delete-project <name>`, "delete
project <name>" or "delete the <name> project". It is never used because
nothing is outstanding on a project; such a project keeps its entry and
note. It is the only skill that deletes a project.

It deletes the written record of a piece of work: its `PROJECTS.md` entry
and its `project_<name>.md` note. Unless the project keeps `Projects/` under
version control, this cannot be undone. It touches no application code, reverts, commits,
deploys and restarts nothing, and deletes no other file. It does not need a
fresh session.

### Steps

1. **Get the name.** With none given it asks, and suggests `/list-projects`.
   One project per run.

2. **Find the project** in `PROJECTS.md` and among the `project_*.md` notes
   in `Projects/`, including `Projects/archive/`. Several matches: it lists them and asks which. No
   match: it says so and stops.

3. **Show exactly what would be deleted:** the entry's title, `Where:` and
   `Next:` lines and its count of outstanding items; the full path of the
   note; and every other file that refers to the note. If the entry lists
   outstanding or uncommitted work, it says that deleting the record only
   stops tracking that work.

4. **Ask for confirmation,** saying it cannot be undone. The name in the
   command is not the confirmation; the yes must come after step 3. Where
   `Projects/` has an `archive/` sub-directory, it offers moving
   the note there instead. Without a clear yes it changes nothing.

5. **Delete** only what step 3 showed: the entry from `PROJECTS.md` (never
   the file or a section heading), the note, and any `AGENTS.md` line that
   points at the note. Other files that mention the note are left alone.

6. **Report:** the entry removed, the note deleted or archived, any
   `AGENTS.md` line removed, and any references left behind.

## Installing and sharing

`README.md` in this repository explains how to install the skills, how to
update them, and how to remove them. To give the skills to someone else,
send them the address of the repository.

In each project nothing is set up in advance. The first `/save-project`
creates `PROJECTS.md` and the `Projects/` directory in that project's root.
A project that wants its records under version control adds those two to
it; the skills do not do that.

## Keeping this document current

This file is updated in the same change as any change to a skill: a rename,
a new or changed step, a changed trigger, or a change to where the state
lives. `README.md` carries a one-line summary of each skill and is updated
at the same time.
