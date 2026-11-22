# Projects

One entry per project worked on in this repository, and what is outstanding
on it. A project is never finished and its entry is never deleted: with
nothing outstanding it stays, with `Next: Nothing outstanding.` Detail for
each entry is in the named note under `Projects/`.

**Project management skills** — `project_project-management-skills.md`
Where: the twelve skills, commands, documentation and README are committed on master and pushed to the public GitHub repository blakemcbride/OpenCodeProjectSkill (20c58a3); the install scripts and their documentation changes are uncommitted; on the owner's machine the skills and commands are linked into `~/.config/opencode/`
Next: Owner: try `/list-projects` in a fresh OpenCode session as the first test; all twelve skills and twelve commands are installed and discovered, and `/status-projects` has been run once, read-only.

- [ ] Owner: commit and push `install.sh`, `install.ps1` and their documentation changes on master when ready; the port is complete and `install.sh` is tested.
- [ ] Owner: try `/rename-project`, `/archive-project`, `/unarchive-project`, `/merge-project` and `/split-project`; they were added on 2026-11-22 and none has been run.
- [ ] Owner: run `/list-projects`, then the other eleven, in a fresh OpenCode session; the twelve skills and twelve commands are installed and discovered, but apart from one read-only `/status-projects` none has been run yet.
- [ ] Owner: try `/resume-project <name>` and `/new-project <name>` in a fresh OpenCode session; neither has been run since the fresh-session check, the loose-match question, the status-only exemption and the archived-project handling were added.
- [ ] Owner: try `/delete-project` on a project that is no longer wanted; it has never been run, including its new offer of `/archive-project` instead.
- [ ] Owner: decide what `save-project` should do when the session was started in a different directory from the one holding the project's record. The skill says the record is in the directory the session was started in; this project was saved from a session started elsewhere, and the save was pointed here by hand.
- [ ] Optional, the agent when asked: `install.ps1` has not been run on Windows. `install.sh` has been run in copy, link and uninstall modes against temporary project and global config directories, but not on another account or machine.
