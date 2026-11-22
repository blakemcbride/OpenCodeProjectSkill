#!/bin/sh
# Install, update or remove the project skills and commands on Linux or macOS.
# Run it from a clone of the repository:  ./install.sh --help

set -eu

usage() {
    cat <<'EOF'
Usage: ./install.sh [--link] [--project DIR] [--uninstall]

  (no option)     Copy the skills and commands into ~/.config/opencode, for
                  every project. Run it again after "git pull" to update them.
  --link          Link them instead of copying them, so that "git pull"
                  updates the installed skills and commands as well.
  --project DIR   Install into DIR/.opencode, for that project only.
  --uninstall     Remove the skills and commands. PROJECTS.md and Projects/ in
                  your projects are left alone.
  -h, --help      Show this text.

If OPENCODE_CONFIG_DIR is set, it is used in place of the config directory
(~/.config/opencode, or $XDG_CONFIG_HOME/opencode when that is set).
EOF
}

mode=copy
project=

while [ $# -gt 0 ]; do
    case $1 in
        --link) mode="link" ;;
        --uninstall) mode=uninstall ;;
        --project)
            [ $# -ge 2 ] || { echo "install.sh: --project needs a directory" >&2; exit 2; }
            project=$2
            shift ;;
        -h|--help) usage; exit 0 ;;
        *) echo "install.sh: unknown option: $1" >&2; usage >&2; exit 2 ;;
    esac
    shift
done

root=$(cd "$(dirname "$0")" && pwd -P)
src_skills=$root/skills
src_commands=$root/commands
[ -d "$src_skills" ] || { echo "install.sh: no skills directory beside this script" >&2; exit 1; }
[ -d "$src_commands" ] || { echo "install.sh: no commands directory beside this script" >&2; exit 1; }

if [ -n "$project" ]; then
    [ -d "$project" ] || { echo "install.sh: not a directory: $project" >&2; exit 1; }
    config=$(cd "$project" && pwd -P)/.opencode
else
    config=${OPENCODE_CONFIG_DIR:-${XDG_CONFIG_HOME:-$HOME/.config}/opencode}
fi
dest_skills=$config/skills
dest_commands=$config/commands

if [ "$mode" != uninstall ]; then
    mkdir -p "$dest_skills" "$dest_commands"
    if [ "$(cd "$dest_skills" && pwd -P)" = "$src_skills" ]; then
        echo "install.sh: $dest_skills is this repository's own skills directory" >&2
        exit 1
    fi
    if [ "$(cd "$dest_commands" && pwd -P)" = "$src_commands" ]; then
        echo "install.sh: $dest_commands is this repository's own commands directory" >&2
        exit 1
    fi
fi

# Remove one installed item: a link is unlinked, a directory or file is
# deleted, and one that is missing is not an error.
remove() {
    target=$1
    if [ -L "$target" ]; then
        rm -f "${target:?}"
    elif [ -e "$target" ]; then
        rm -rf "${target:?}"
    else
        return 1
    fi
}

skills=0
for dir in "$src_skills"/*/; do
    [ -f "${dir}SKILL.md" ] || continue
    name=$(basename "$dir")
    target=$dest_skills/$name
    case $mode in
        copy)
            remove "$target" || true
            cp -R "$src_skills/$name" "$target" ;;
        link)
            remove "$target" || true
            ln -s "$src_skills/$name" "$target" ;;
        uninstall)
            remove "$target" || continue ;;
    esac
    skills=$((skills + 1))
done

commands=0
for file in "$src_commands"/*.md; do
    [ -f "$file" ] || continue
    name=$(basename "$file")
    target=$dest_commands/$name
    case $mode in
        copy)
            remove "$target" || true
            cp "$file" "$target" ;;
        link)
            remove "$target" || true
            ln -s "$file" "$target" ;;
        uninstall)
            remove "$target" || continue ;;
    esac
    commands=$((commands + 1))
done

case $mode in
    copy) echo "Copied $skills skills and $commands commands to $config" ;;
    link) echo "Linked $skills skills and $commands commands in $config to $root" ;;
    uninstall) echo "Removed $skills skills and $commands commands from $config" ;;
esac
[ "$mode" = uninstall ] || echo "Start a new OpenCode session; / lists the commands."