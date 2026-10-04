#!/usr/bin/env bash
# یک پروژهٔ تازه از روی استارتر کیت می‌سازد.
set -euo pipefail

KIT="$(cd "$(dirname "$0")/.." && pwd)"

usage() {
  cat <<USAGE
Usage: bin/new-project.sh <target-dir>                 step-by-step setup (asks what to install)
       bin/new-project.sh <target-dir> [--with <parts>] [--skills <ids>] [--stack <id>]
                          [--design-system <id>] [--name <slug>] [--dry-run]
       bin/new-project.sh --list

  --with            comma-separated parts: skills, graphify, workflow, docs, spec, or all
  --skills          comma-separated skill ids from skills/agents (instead of all of them)
  --stack           one of stacks/
  --design-system   one of design-systems/
  --name            project slug (default: target dir name, lowercased)
  --dry-run         print what would be created; write nothing
  --interactive     force the step-by-step setup (default in a terminal when nothing is named)
  --list            show parts, skills, stacks and design systems

Nothing is installed unless it is named. Existing files in <target-dir> are never overwritten.
USAGE
}

list_dir() {
  for d in "$KIT/$1"/*/; do
    id="$(basename "$d")"
    [ "$id" = "_template" ] && continue
    printf "  %-22s %s\n" "$id" "$(head -n 1 "$d/README.md" | sed 's/^# *//')"
  done
}

list_all() {
  cat <<PARTS
Parts (--with):
  skills                 general agent skills -> .agents/skills/ (narrow with --skills)
  graphify               graphify skill, Claude Code and Codex hooks, .gitattributes
  workflow               AGENTS.md, CLAUDE.md, docs/TASK_WORKFLOW.md, base .gitignore lines
  docs                   product plan, requirements, security checklist, README templates
  spec                   feature-spec, feature-plan and bug-fix skills -> .agents/skills/, .claude/skills/
PARTS
  echo "Skills (--skills):"
  for d in "$KIT/skills/agents"/*/; do echo "  $(basename "$d")"; done
  echo "Stacks (--stack):"; list_dir stacks
  echo "Design systems (--design-system):"; list_dir design-systems
}

TARGET="" NAME="" STACK="" DS="" WITH="" SKILLS="" DRY=0 INTERACTIVE=0
while [ $# -gt 0 ]; do
  case "$1" in
    --list) list_all; exit 0 ;;
    --name) NAME="${2:?}"; shift 2 ;;
    --with) WITH="${WITH:+$WITH,}${2:?}"; shift 2 ;;
    --skills) SKILLS="${SKILLS:+$SKILLS,}${2:?}"; shift 2 ;;
    --stack) STACK="${2:?}"; shift 2 ;;
    --design-system) DS="${2:?}"; shift 2 ;;
    --dry-run) DRY=1; shift ;;
    --interactive) INTERACTIVE=1; shift ;;
    -h|--help) usage; exit 0 ;;
    -*) echo "Unknown option: $1" >&2; usage >&2; exit 1 ;;
    *) [ -z "$TARGET" ] || { usage >&2; exit 1; }; TARGET="$1"; shift ;;
  esac
done
[ -n "$TARGET" ] || { usage >&2; exit 1; }

for p in $(echo "$WITH" | tr ',' ' '); do
  case "$p" in
    all) WITH="skills,graphify,workflow,docs,spec" ;;
    skills|graphify|workflow|docs|spec) ;;
    *) echo "Unknown part: $p" >&2; list_all >&2; exit 1 ;;
  esac
done
[ -n "$SKILLS" ] && WITH="${WITH:+$WITH,}skills"
for s in $(echo "$SKILLS" | tr ',' ' '); do
  [ -d "$KIT/skills/agents/$s" ] || { echo "Unknown skill: $s" >&2; list_all >&2; exit 1; }
done
if [ -n "$STACK" ] && { [ "$STACK" = "_template" ] || [ ! -d "$KIT/stacks/$STACK" ]; }; then
  echo "Unknown stack: $STACK" >&2; list_dir stacks >&2; exit 1
fi
if [ -n "$DS" ] && { [ "$DS" = "_template" ] || [ ! -d "$KIT/design-systems/$DS" ]; }; then
  echo "Unknown design system: $DS" >&2; list_dir design-systems >&2; exit 1
fi

# راه‌اندازی مرحله‌به‌مرحله: هر مرحله یک سؤال، آخرش پیش‌نمایش و تأیید.
ask() { printf "%s " "$1" >&2; IFS= read -r REPLY || REPLY=""; }
yes_no() { ask "$1 [y/N]"; case "$REPLY" in y|Y|yes|Yes) return 0 ;; *) return 1 ;; esac; }

# از بین پوشه‌های یک رجیستری یکی را با شماره انتخاب می‌کند؛ 0 یعنی هیچ‌کدام.
pick_one() {
  PICKED=""
  ids="$(for d in "$KIT/$1"/*/; do id="$(basename "$d")"; [ "$id" = "_template" ] || echo "$id"; done)"
  echo "  0) none" >&2
  i=0
  for id in $ids; do
    i=$((i + 1))
    printf "  %d) %-22s %s\n" "$i" "$id" "$(head -n 1 "$KIT/$1/$id/README.md" | sed 's/^# *//')" >&2
  done
  ask "Number [0]:"
  i=0
  for id in $ids; do i=$((i + 1)); [ "$REPLY" = "$i" ] && PICKED="$id"; done
  return 0
}

wizard() {
  echo "Setup for: $TARGET" >&2
  echo "Nothing is written until you confirm at the end. Enter = no." >&2

  echo >&2; echo "Step 1/5 - Agent layer" >&2
  yes_no "  graphify: knowledge-graph skill and hooks for Claude Code and Codex?" && WITH="${WITH:+$WITH,}graphify"
  yes_no "  workflow: AGENTS.md, CLAUDE.md and the 9-step task workflow?" && WITH="${WITH:+$WITH,}workflow"
  yes_no "  docs: product plan, requirements and security checklist templates?" && WITH="${WITH:+$WITH,}docs"
  yes_no "  spec: feature-spec, feature-plan and bug-fix skills?" && WITH="${WITH:+$WITH,}spec"

  echo >&2; echo "Step 2/5 - General skills" >&2
  i=0
  for d in "$KIT/skills/agents"/*/; do
    i=$((i + 1))
    desc="$(awk '/^description:/{sub(/^description: */,""); if ($0 ~ /^[>|]/ || $0 == "") {getline; sub(/^ +/,"")} print; exit}' "$d/SKILL.md" | cut -c1-80)"
    printf "  %2d) %-22s %s\n" "$i" "$(basename "$d")" "$desc" >&2
  done
  ask "Numbers separated by spaces, 'all', or Enter for none:"
  case "$REPLY" in
    "") ;;
    all) WITH="${WITH:+$WITH,}skills" ;;
    *)
      for n in $REPLY; do
        i=0
        for d in "$KIT/skills/agents"/*/; do
          i=$((i + 1))
          [ "$n" = "$i" ] && SKILLS="${SKILLS:+$SKILLS,}$(basename "$d")"
        done
      done ;;
  esac

  echo >&2; echo "Step 3/5 - Stack (boilerplate; skip it on a project that already has code)" >&2
  pick_one stacks; STACK="$PICKED"

  echo >&2; echo "Step 4/5 - Design system (skip it on a project that already has its own UI)" >&2
  pick_one design-systems; DS="$PICKED"

  set -- "$TARGET"
  [ -n "$NAME" ] && set -- "$@" --name "$NAME"
  [ -n "$WITH" ] && set -- "$@" --with "$WITH"
  [ -n "$SKILLS" ] && set -- "$@" --skills "$SKILLS"
  [ -n "$STACK" ] && set -- "$@" --stack "$STACK"
  [ -n "$DS" ] && set -- "$@" --design-system "$DS"
  if [ $# -eq 1 ] || { [ $# -eq 3 ] && [ -n "$NAME" ]; }; then
    echo >&2; echo "Nothing selected, nothing installed." >&2; exit 0
  fi

  echo >&2; echo "Step 5/5 - Review" >&2
  echo "Command: bin/new-project.sh $*" >&2
  "$0" "$@" --dry-run >&2
  if yes_no "Install this?"; then exec "$0" "$@"; fi
  echo "Cancelled, nothing installed." >&2; exit 0
}

# بدون انتخاب: در ترمینال راه‌اندازی مرحله‌به‌مرحله، وگرنه فقط فهرست گزینه‌ها. چیزی نصب نمی‌شود.
if [ -z "$WITH" ] && [ -z "$STACK" ] && [ -z "$DS" ]; then
  if [ "$INTERACTIVE" = 1 ] || [ -t 0 ]; then wizard; fi
  {
    echo "Nothing selected, nothing installed."
    echo "If you are an AI agent: ask the user step by step, one question per step -"
    echo "1) agent-layer parts, 2) which skills, 3) stack, 4) design system - then run the"
    echo "command with --dry-run, show the result, and install only after they confirm."
    echo "Do not pick for them, and do not add a design system or a stack to a project"
    echo "that already has its own."
    echo
    list_all
    echo
    echo "Example: bin/new-project.sh $TARGET --with graphify,workflow --skills webapp-testing --dry-run"
  } >&2
  exit 2
fi

has_part() { case ",$WITH," in *",$1,"*) return 0 ;; *) return 1 ;; esac; }

if [ "$DRY" = 1 ] && [ ! -d "$TARGET" ]; then
  case "$TARGET" in /*) ;; *) TARGET="$PWD/$TARGET" ;; esac
else
  mkdir -p "$TARGET"
  TARGET="$(cd "$TARGET" && pwd)"
fi
if [ -z "$NAME" ]; then
  NAME="$(basename "$TARGET" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9_]/_/g')"
fi
case "$NAME" in
  ""|*[!a-z0-9_]*) echo "Project name must be lowercase letters, digits or underscores: $NAME" >&2; exit 1 ;;
esac
[ "$DRY" = 1 ] && echo "Dry run: nothing is written."

NEW_FILES="$(mktemp)"
trap 'rm -f "$NEW_FILES"' EXIT

# یک فایل را فقط وقتی کپی می‌کند که در مقصد نباشد.
copy_file() {
  if [ -e "$2" ]; then
    echo "  skip (exists): ${2#"$TARGET"/}"
  elif [ "$DRY" = 1 ]; then
    echo "  would create: ${2#"$TARGET"/}"
  else
    mkdir -p "$(dirname "$2")"
    cp -p "$1" "$2"
    echo "$2" >> "$NEW_FILES"
  fi
}

# یک پوشه را فایل‌به‌فایل کپی می‌کند.
copy_tree() {
  [ -d "$1" ] || return 0
  (cd "$1" && find . -type f ! -name .gitkeep ! -name .DS_Store) | while read -r f; do
    f="${f#./}"
    dest="$2/$f"
    [ "$f" = "gitignore" ] && dest="$2/.gitignore"
    copy_file "$1/$f" "$dest"
  done
}

# اسکیل‌ها فایل‌های زیادی دارند؛ هر اسکیل یک‌جا کپی می‌شود و در فهرست جایگزینی نام نمی‌آید.
# آرگومان سوم فهرست اسکیل‌های انتخاب‌شده است؛ اگر خالی باشد همه کپی می‌شوند.
copy_skills() {
  ids="$(echo "${3:-}" | tr ',' ' ')"
  [ -n "$ids" ] || ids="$(for s in "$1"/*/; do basename "$s"; done)"
  for id in $ids; do
    if [ -e "$2/$id" ]; then
      echo "  skip (exists): ${2#"$TARGET"/}/$id"
    elif [ "$DRY" = 1 ]; then
      echo "  would create: ${2#"$TARGET"/}/$id/"
    else
      mkdir -p "$2"
      cp -Rp "$1/$id" "$2/$id"
    fi
  done
}

# خط‌هایی که در .gitignore نیستند اضافه می‌شوند.
add_gitignore() {
  while IFS= read -r line; do
    grep -qxF "$line" "$TARGET/.gitignore" 2>/dev/null && continue
    if [ "$DRY" = 1 ]; then echo "  would add to .gitignore: $line"; else echo "$line" >> "$TARGET/.gitignore"; fi
  done
}

if has_part skills; then
  echo "Skills"
  copy_skills "$KIT/skills/agents" "$TARGET/.agents/skills" "$SKILLS"
fi

if has_part graphify; then
  echo "graphify"
  copy_skills "$KIT/skills/claude" "$TARGET/.claude/skills"
  copy_skills "$KIT/skills/codex" "$TARGET/.codex/skills"
  copy_file "$KIT/config/claude/settings.json" "$TARGET/.claude/settings.json"
  copy_file "$KIT/config/codex/hooks.json" "$TARGET/.codex/hooks.json"
  copy_file "$KIT/config/gitattributes" "$TARGET/.gitattributes"
  grep graphify "$KIT/config/gitignore" | add_gitignore
fi

if has_part workflow; then
  echo "Workflow"
  copy_file "$KIT/workflow/TASK_WORKFLOW.md" "$TARGET/docs/TASK_WORKFLOW.md"
  grep -v graphify "$KIT/config/gitignore" | add_gitignore
fi

if has_part docs; then
  echo "Docs"
  copy_file "$KIT/docs-templates/PRODUCT_PLAN.md" "$TARGET/docs/PRODUCT_PLAN.md"
  copy_file "$KIT/docs-templates/REQUIREMENTS_ARCHITECTURE.md" "$TARGET/docs/REQUIREMENTS_ARCHITECTURE.md"
  copy_file "$KIT/docs-templates/SECURITY_RELEASE_CHECKLIST.md" "$TARGET/docs/SECURITY_RELEASE_CHECKLIST.md"
  copy_file "$KIT/docs-templates/README.md" "$TARGET/README.md"
fi

if has_part spec; then
  echo "Spec"
  copy_skills "$KIT/skills/spec" "$TARGET/.agents/skills"
  copy_skills "$KIT/skills/spec" "$TARGET/.claude/skills"
fi

FRONTEND_DIR="."
if [ -n "$STACK" ]; then
  echo "Stack: $STACK"
  copy_tree "$KIT/stacks/$STACK/files" "$TARGET"
  if [ -f "$KIT/stacks/$STACK/stack.env" ]; then
    FRONTEND_DIR="$(sed -n 's/^FRONTEND_DIR=//p' "$KIT/stacks/$STACK/stack.env")"
  fi
fi

if [ -n "$DS" ]; then
  echo "Design system: $DS"
  DS_DIR="$TARGET"
  [ "${FRONTEND_DIR:-.}" = "." ] || DS_DIR="$TARGET/$FRONTEND_DIR"
  copy_tree "$KIT/design-systems/$DS/files" "$DS_DIR"
fi

# AGENTS.md: قالب روند کار (اگر انتخاب شده) به‌علاوهٔ قانون‌های استک و دیزاین سیستم انتخاب‌شده.
STACK_RULES="" DS_RULES=""
[ -n "$STACK" ] && [ -f "$KIT/stacks/$STACK/AGENT_RULES.md" ] && STACK_RULES="$KIT/stacks/$STACK/AGENT_RULES.md"
[ -n "$DS" ] && [ -f "$KIT/design-systems/$DS/AGENT_RULES.md" ] && DS_RULES="$KIT/design-systems/$DS/AGENT_RULES.md"
if has_part workflow || [ -n "$STACK_RULES$DS_RULES" ]; then
  if [ -e "$TARGET/AGENTS.md" ]; then
    echo "  skip (exists): AGENTS.md"
    for r in $STACK_RULES $DS_RULES; do echo "  add these rules to AGENTS.md by hand: $r"; done
  elif [ "$DRY" = 1 ]; then
    echo "  would create: AGENTS.md"
    [ -e "$TARGET/CLAUDE.md" ] || echo "  would create: CLAUDE.md"
  else
    {
      if ! has_part workflow; then
        echo "# __PROJECT__"
      elif has_part graphify; then
        cat "$KIT/workflow/AGENTS.template.md"
      else
        awk '/^## graphify$/{skip=1; next} /^## /{skip=0} !skip' "$KIT/workflow/AGENTS.template.md"
      fi
      for r in $STACK_RULES $DS_RULES; do echo; cat "$r"; done
    } > "$TARGET/AGENTS.md"
    echo "$TARGET/AGENTS.md" >> "$NEW_FILES"
    [ -e "$TARGET/CLAUDE.md" ] || echo "@AGENTS.md" > "$TARGET/CLAUDE.md"
  fi
fi

# نام پروژه فقط در فایل‌هایی که همین حالا ساخته شدند جایگزین می‌شود.
while IFS= read -r f; do
  if grep -q "__PROJECT__" "$f" 2>/dev/null; then
    NAME="$NAME" perl -pi -e 's/__PROJECT__/$ENV{NAME}/g' "$f"
  fi
done < "$NEW_FILES"

echo
if [ "$DRY" = 1 ]; then echo "Dry run finished: $TARGET (name: $NAME)"; exit 0; fi
echo "Done: $TARGET (name: $NAME)"
[ -n "$STACK" ] && echo "Next steps for the stack:         $KIT/stacks/$STACK/README.md"
[ -n "$DS" ] && echo "Next steps for the design system: $KIT/design-systems/$DS/README.md"
if has_part graphify; then echo "Then: git init && graphify update ."; fi
