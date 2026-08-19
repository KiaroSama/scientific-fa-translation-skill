#!/usr/bin/env bash
# Verify or perform the Cursor personal-skills install for this repository.
#
#   ./skills-install.sh [--check]
#
# Cursor discovers `~/.cursor/skills/<skill-name>/SKILL.md`. Two layouts work,
# and this script handles both:
#
#   A. the repository itself is cloned as ~/.cursor/skills, with each skill at
#      the repository root — nothing to link, just verify;
#   B. the repository lives elsewhere, and each top-level skill folder is
#      symlinked into ~/.cursor/skills.
#
# The layout that does NOT work is a skill nested deeper than one level, e.g.
# ~/.cursor/skills/<repo>/<skill>/SKILL.md or a `.cursor/skills/` directory
# inside the repository. This script fails loudly on that.
set -uo pipefail

check_only=0
[[ ${1:-} == --check ]] && check_only=1

repo=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)
# ~/.cursor may not exist yet; resolve it without letting an empty
# substitution turn the target into /skills.
cursor_dir=$(cd "$HOME/.cursor" 2>/dev/null && pwd -P \
             || printf '%s' "$HOME/.cursor")
target="$cursor_dir/skills"
target_real=$(readlink -f "$target" 2>/dev/null || printf '%s' "$target")
fail=0

skills=()
for dir in "$repo"/*/; do
  [[ -f "$dir/SKILL.md" ]] && skills+=("$(basename "$dir")")
done

if [[ ${#skills[@]} -eq 0 ]]; then
  echo "error: no <name>/SKILL.md at the root of $repo" >&2
  exit 1
fi

# The nesting bug: a skill one level too deep is invisible to Cursor.
if [[ -d "$repo/.cursor/skills" ]]; then
  echo "error: $repo/.cursor/skills exists." >&2
  echo "Skills must sit at the repository root as <name>/SKILL.md." >&2
  fail=1
fi

if [[ $repo == "$target_real" ]]; then
  echo "layout: repository is installed as $target"
  for name in "${skills[@]}"; do
    echo "ok      $name -> $target/$name/SKILL.md"
  done
elif [[ $repo == "$target_real"/* ]]; then
  echo "error: this clone is nested inside $target ($repo)." >&2
  echo "Cursor only looks one level deep. Either move the clone out and" >&2
  echo "re-run this script, or clone the repository as $target itself." >&2
  exit 1
else
  echo "layout: symlinking skills into $target"
  if ! mkdir -p "$target"; then
    echo "error: cannot create $target" >&2
    exit 1
  fi
  for name in "${skills[@]}"; do
    src="$repo/$name"
    link="$target/$name"
    if [[ -L $link ]]; then
      if [[ $(readlink -f "$link") == "$(readlink -f "$src")" ]]; then
        echo "ok      $name"
        continue
      fi
      if [[ $check_only -eq 1 ]]; then
        echo "STALE   $name points at $(readlink -f "$link")"
        fail=1
        continue
      fi
      if ln -sfn "$src" "$link"; then
        echo "relink  $name"
      else
        echo "FAIL    $name: could not relink $link"
        fail=1
      fi
    elif [[ -e $link ]]; then
      echo "SKIP    $name: $link exists and is not a symlink; move it aside"
      fail=1
    elif [[ $check_only -eq 1 ]]; then
      echo "MISSING $name is not installed"
      fail=1
    elif ln -s "$src" "$link"; then
      echo "link    $name"
    else
      echo "FAIL    $name: could not link $link"
      fail=1
    fi
  done
fi

echo
if [[ $fail -eq 0 ]]; then
  echo "${#skills[@]} skill(s) discoverable under $target"
  echo "After a git pull, start a NEW agent on branch main — follow-ups in a"
  echo "running agent do not reliably reload skills."
else
  echo "some skills need attention (see above)"
fi
exit $fail
