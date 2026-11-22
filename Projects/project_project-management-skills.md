# Project management skills

Twelve OpenCode skills that keep the state of each project in plain files:
`new-project`, `resume-project`, `save-project`, `list-projects`,
`describe-project`, `status-projects`, `rename-project`, `archive-project`,
`unarchive-project`, `merge-project`, `split-project`, `delete-project`.
Each has a matching command so it can be run as `/save-project` and the like.
This repository is their one source and also keeps this record of the work
on them.

## Where everything is

- This repository (branch `master`, public on GitHub as
  `blakemcbride/OpenCodeProjectSkill`, MIT).
  - `skills/<name>/SKILL.md` — the twelve skills.
  - `commands/<name>.md` — one command per skill, for `/name`.
  - `ProjectSkills.md` — full documentation of every step.
  - `README.md` — public introduction, install, use, update, remove.
  - `AGENTS.md` — the rules for working in this repository.
  - `PROJECTS.md` and `Projects/` — this project's own saved state.
- On the owner's machine `~/.config/opencode/skills/<name>` for each skill and
  `~/.config/opencode/commands/<name>.md` for each command are links into this
  repository, so editing a skill or command through either path edits this
  repository. The links are made (2026-11-22).
- The Claude Code version of the same skills is a separate repository,
  `blakemcbride/ClaudeCodeProjectSkill`. It reads and writes the same
  `PROJECTS.md` and `Projects/project_<name>.md`, in the same place and
  format, so a project saved under one harness is resumed under the other.

## Conversion from the Claude Code version

- The six skills were converted from the Claude Code skills of the same
  names. The logic and the written-state format are unchanged.
- Each skill also has a command in `commands/<name>.md`, because OpenCode runs
  `/save-project` and the like as commands, not skills. The command is thin:
  it tells the model to call the `skill` tool with the skill's id and follow
  it. The steps live in the skill only, so the two cannot drift.
- OpenCode-specific changes: skill install path `~/.claude/skills` →
  `~/.config/opencode/skills`, with commands in
  `~/.config/opencode/commands`; the fresh-session instruction uses `/new`
  (or a new `opencode`) instead of `/clear`; lasting rules go in `AGENTS.md`
  (or the global `~/.config/opencode/AGENTS.md`) instead of a `MEMORY.md`
  memory; and the README's opening describes OpenCode's session store and
  lossy compaction instead of Claude Code's purged, detailed sessions.
- The saved state and its location are deliberately identical to the Claude
  Code version, so the two share one state per project.

## Later Claude Code additions, ported

- On 2026-11-22 the six skills added to the Claude Code version were ported
  unchanged in logic: `status-projects`, `rename-project`, `archive-project`,
  `unarchive-project`, `merge-project` and `split-project`, each with a
  command here. The six earlier skills also took the Claude Code changes
  that affect them: the archive awareness in `resume-project`, `save-project`,
  `list-projects` and `delete-project`, and the archive alternative offered
  by `delete-project`.
- The same harness substitutions apply as in the first conversion, so the
  skills still say `AGENTS.md` where the Claude Code version says
  `MEMORY.md`, use the OpenCode install paths, and use `/new` or a new
  `opencode` for a fresh session.
- Archived projects keep their entry, word for word, inside the note under
  `## Archived PROJECTS.md entry`, so the state stays in the same place and
  format the Claude Code version reads and writes.

## Decisions the owner made, and why

- **A project is never finished.** More corrections and enhancements are
  always possible. No skill marks a project done or closed. With nothing
  outstanding an entry stays, with `Next: Nothing outstanding.`
- **`save-project` is a checkpoint, not an ending.** It runs at any time,
  including mid-work, records what is in flight without stopping or cleaning
  it up, and the work then continues. It was first called `wrap-up`, then
  `end-project`; both names were dropped because they implied an ending.
- **`save-project` never deletes a project.** Only `delete-project` removes
  an entry or note, on an explicit request, after showing what will go and
  getting a yes. `resume-project` likewise deletes done items but never an
  entry or note.
- **Notes live in the project, not in the harness's data directory**, so that
  nothing the harness stores or clears can reach them. The owner wanted to be
  sure nothing is auto-deleted.
- **The status file is `PROJECTS.md`** (was `OPEN.md`).
- **`new-project` is a pure alias** for `resume-project` and holds no steps of
  its own.
- **Fresh session first.** `resume-project` (and so `new-project`) refuses to
  run in a session that already holds other work and tells the user to start
  a fresh session with `/new` or a new `opencode`. Status-only questions
  ("where are we on X") are exempt and answered in place, but the work is not
  continued there.
- **Loose match asks first** in `resume-project`; an exact match (whole title
  or note name) resumes without asking. `describe-project` uses a loose match
  without asking because it changes nothing.
- **`save-project` checks a new name for a collision** (equal to, containing,
  or contained in an existing title or note name) so a name can never be a
  loose match for another project.
- **`list-projects` is brief:** names only, one comma-separated line per
  section, plus the total. Detail comes from `describe-project`, which was
  added for that purpose and reads only the entry and the note.
- **Section headings in `PROJECTS.md` are categories, not projects.**
- **Purposes the owner named:** one session per piece of work instead of
  weeks-long sessions, and saving tokens, since a fresh session reads only a
  few kilobytes of state where a long or reopened session re-sends its whole
  history each turn.
- **The steps live in the skill, not the command.** The command is a thin
  loader so there is one copy of the steps; the model can also load the skill
  from plain words.
- **How the owner presents the skills publicly**, and so how `README.md`
  opens: OpenCode already saves and resumes sessions, but a saved session
  (1) holds far too much detail and uses unnecessary tokens, (2) is compacted
  lossily when it grows long, and (3) is stored in OpenCode's own data
  directory, which may not be backed up with the project. A "project" does
  essentially what session save and resume does without those three
  shortcomings. Keep the README's opening in that order.
- **Public-facing wording.** Because the repositories are public and the
  installed skills are the same files, the skills, `ProjectSkills.md` and
  `README.md` say "the user", never a person's name, and hold no home
  directory path and nothing specific to one project.
- **Keep the GitHub repository current** as the skills are enhanced: update
  `ProjectSkills.md` and `README.md` in the same task as a skill change.
  Committing and pushing need the owner's request each time.
- **The saved state is shared with the Claude Code version.** A project's
  `PROJECTS.md` and `Projects/` are the same files either harness uses, so the
  two versions stay interchangeable on one project.
- **The OpenCode version tracks the Claude Code version.** Every enhancement
  or addition to the Claude Code skills is ported here in the same task, so
  the two stay equivalent apart from harness wording and install paths.
- **This project's own record lives here**, not in another project, because
  the skills are not specific to any one project. It is written for a public
  repository: no person's name, no home directory path, no other project's
  name.

## Rejected

- **Making the skills clear the session themselves.** OpenCode offers no way
  for a skill or command to start a fresh session for the user. Two
  substitutes were offered and the owner chose neither: a plugin that picks
  up a saved project name once a new session is started, and launching a new
  terminal running `opencode "/resume-project <name>"`.

## Traps

- A skill or command runs in the session it is typed in; it cannot start a
  fresh one.
- The skills are instructions, not code: a change is tested by running the
  skill, not by a build.
- The install is discovered: `opencode api get /api/skill` lists all twelve
  ids and `opencode api get /api/command` lists all twelve commands. The
  `~/.config/opencode/` copy of a skill takes precedence over the identical
  id in `~/.claude/skills`.
- A command template does not expand `@`-mentions, so a command cannot load a
  skill by writing `@save-project`; it must tell the model to call the `skill`
  tool with the skill's id.
- Because the installed skills and commands are links, a half-made edit here
  is live in every OpenCode session on the machine at once.
- OpenCode also discovers `~/.claude/skills` for compatibility, so the Claude
  Code version of these skills is visible to it as well. The
  `~/.config/opencode/` copy takes precedence, which is why the OpenCode
  wording wins there.
- The skills take the project root to be the directory the session was
  started in. Work on these skills is often done from a session started in
  another project; a save from there has to be pointed at this repository's
  `PROJECTS.md` and `Projects/` deliberately.
- Saving this record changes tracked files, so the repository shows
  uncommitted changes after every save until the owner asks for a commit.
