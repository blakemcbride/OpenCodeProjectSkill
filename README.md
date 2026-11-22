# OpenCode Project Skills

[OpenCode](https://opencode.ai) saves your sessions and lets you resume them.
That is useful, but it has three problems:

1. **A saved session holds far too much detail.** It is the whole
   conversation, and all of it is sent to the model again on every turn,
   using tokens that are not needed.
2. **A long session is compacted lossily.** When it approaches the model's
   context limit, OpenCode replaces the older conversation with a summary.
   What the summary leaves out is gone.
3. **Saved sessions are stored outside your project.** They are kept in
   OpenCode's own data directory, not in your project, so they may not be
   backed up with it.

These twelve skills manage what they call *projects*. A project does
essentially what session save and resume does, without those three
shortcomings:

1. **Only what matters is kept.** A project's saved state is a short
   summary: where the work stands, the next step, what is outstanding, and
   the decisions and traps a new session could not work out from the code. A
   fresh session that reads it starts with a few kilobytes, not a whole
   conversation.
2. **Nothing is lost to compaction.** A project's saved state is written in
   full and stays as written until you change it yourself.
3. **It is stored in your project.** The saved state is plain Markdown files
   in your project's own directory, so it is backed up and copied along with
   everything else there, and can be put under version control.

A long session also loses detail every time its context is compacted. A
saved project does not: you save where it stands, close the session whenever
you like, and start the next one by reading the record back.

The saved state has the same format, in the same place, as the
[Claude Code version](https://github.com/blakemcbride/ClaudeCodeProjectSkill)
of these skills, so a project saved under one is resumed under the other.

> This is an independent project. It is not made or supported by OpenCode.

## The skills

Each skill has a matching command, so it can be run as `/save-project` and
the like. OpenCode can also load the matching skill when you ask in plain
words.

| Command | What it does |
|---|---|
| `/save-project` | Saves where the project stands right now. It can be run at any time, including in the middle of work, and the work then continues. |
| `/resume-project <name>` | In a fresh session, reads the project's saved state, checks it against version control, reports where things stand, and continues the work. |
| `/new-project <name>` | Alias for `/resume-project`. |
| `/list-projects [words]` | Lists the names of the recorded projects. Changes nothing. |
| `/describe-project <name>` | Shows the detail of one project from its saved state. Changes nothing. |
| `/status-projects [words]` | Shows one line per project: its name, its next step and how many items are outstanding. Changes nothing. |
| `/rename-project <name> to <new name>` | Renames a project and fixes the references to it. |
| `/archive-project <name>` | Sets a project aside without deleting it. Its saved state moves to `Projects/archive/`. |
| `/unarchive-project [name]` | Brings an archived project back. With no name it lists the archived projects. |
| `/merge-project <name> into <other>` | Folds one project into another, after showing the plan and asking for confirmation. |
| `/split-project <name> [into <new name>]` | Makes two projects of one, after showing the plan and asking for confirmation. |
| `/delete-project <name>` | Deletes a project's saved state, after showing what will go and asking for confirmation. |

OpenCode also loads a skill when you ask in plain words, for example "save
where we are" or "where are we on the import work".

[ProjectSkills.md](ProjectSkills.md) describes every step of every skill.

## How it works

The skills keep two things in the root of your project, the directory the
session was started in:

- `PROJECTS.md` holds one entry per project: a title, where it stands, the
  next step, and a checklist of what is outstanding.
- `Projects/project_<name>.md` holds one note per project with what a new
  session cannot work out from the code: the decisions made and why, the
  design, the files that matter, and the traps found along the way.

Both are ordinary Markdown files that you can read and edit yourself. They
are kept in your project, not in OpenCode's own data directory, so nothing
OpenCode stores or clears can remove them.

Three rules run through all twelve skills:

- **A project is never finished.** More corrections and enhancements are
  always possible, so no skill marks a project as done or closed.
- **Nothing is deleted automatically.** Only `/delete-project` removes a
  project, and only after you confirm. `/archive-project` sets one aside
  and loses nothing, and `/merge-project` moves a project's whole content
  into another before removing it, after you confirm.
- **The skills only write records.** They change no application code and
  never commit, push, deploy or restart anything.

## Requirements

OpenCode. The skills and commands are instructions in Markdown; there is no
program to build and nothing else to install.

`/resume-project` uses `git` or `svn` to compare the saved state with the
working copy, when the project uses one of them.

## Install

Clone the repository:

```
git clone https://github.com/blakemcbride/OpenCodeProjectSkill.git
cd OpenCodeProjectSkill
```

Then run the install script from the cloned directory.

On Linux or macOS:

```
./install.sh
```

On Windows:

```
powershell -ExecutionPolicy Bypass -File install.ps1
```

This copies the twelve skill directories and twelve commands to OpenCode's
config directory: `~/.config/opencode`, or `$XDG_CONFIG_HOME/opencode` when
that is set (`%USERPROFILE%\.config\opencode` on Windows). OpenCode looks
there for them, so they work in every project on your machine. If
`OPENCODE_CONFIG_DIR` is set, the script uses it instead.

For one project only, name the project:

```
./install.sh --project /path/to/your/project
```

```
powershell -ExecutionPolicy Bypass -File install.ps1 -Project C:\path\to\your\project
```

That installs into the project's own `.opencode`.

Start OpenCode. Type `/` to list the commands, and `/list-projects` is a
harmless first test: in a project with no `PROJECTS.md` it says so and stops.

The script installs all twelve skills and all twelve commands. They refer to
each other by name.

### Installing with links instead of copies

If you would rather have the installed skills and commands follow the cloned
repository, link them instead of copying them:

```
./install.sh --link
```

```
powershell -ExecutionPolicy Bypass -File install.ps1 -Link
```

A `git pull` then updates the installed skills and commands as well. On
Windows the skill links are directory junctions, which need no special
rights; the command links are symbolic links, which may need Developer Mode
or an elevated shell.

### Installing by hand

The scripts only copy or link directories and files. Without them:

```
mkdir -p ~/.config/opencode/skills ~/.config/opencode/commands
cp -r skills/* ~/.config/opencode/skills/
cp -r commands/* ~/.config/opencode/commands/
```

## Use

A typical session:

1. Start `opencode` in your project.
2. Type `/resume-project <name>`, or `/new-project <name>` for work that has
   no record yet.
3. Do the work. Type `/save-project` whenever you want a checkpoint.
4. Type `/save-project` before you close the session.

The first `/save-project` in a project creates `PROJECTS.md` and `Projects/`.
If you want them under version control, add them yourself; the skills do not.

`/resume-project` and `/new-project` are meant to be the first thing typed in
a fresh session. A skill or command cannot clear the session it runs in, so
when one of them is typed in a session that already holds other work, it tells
you to start a fresh session first, with `/new` or by starting `opencode`
again. A question that only asks for status, such as "where are we on the
import work", is answered in any session.

## Sharing state with the Claude Code skills

The written state is the same format, in the same place, as the
[Claude Code version](https://github.com/blakemcbride/ClaudeCodeProjectSkill)
of these skills. One project has one `PROJECTS.md` and one `Projects/`, and a
project saved under one harness is resumed under the other. The two versions
install separately; install whichever you use.

## Update

With copies, pull and run the install script again, with the same options as
before. It replaces each of the twelve installed skills and twelve commands:

```
git pull
./install.sh
```

With links, `git pull` is enough. Run the script again only when a pull
brings a new skill or command, which needs its own link.

## Remove

```
./install.sh --uninstall
```

```
powershell -ExecutionPolicy Bypass -File install.ps1 -Uninstall
```

Add `--project` (`-Project`) with the project's directory for a
one-project install.

This removes the skills and commands only. `PROJECTS.md` and `Projects/` in
your projects are yours and are left alone.

## License

MIT. See [LICENSE](LICENSE).
