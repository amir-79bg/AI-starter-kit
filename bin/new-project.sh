#!/usr/bin/env bash
# یک پروژهٔ تازه از روی استارتر کیت می‌سازد.
set -euo pipefail

KIT="$(cd "$(dirname "$0")/.." && pwd)"

usage() {
  cat <<USAGE
Usage: bin/new-project.sh <target-dir> [--with <parts>] [--skills <ids>] [--stack <id>]
                          [--design-system <id>] [--name <slug>] [--dry-run]
       bin/new-project.sh --list

  --with            comma-separated parts: skills, graphify, workflow, docs, or all
  --skills          comma-separated skill ids from skills/agents (instead of all of them)
  --stack           one of stacks/
  --design-system   one of design-systems/
  --name            project slug (default: target dir name, lowercased)
  --dry-run         print what would be created; write nothing
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
PARTS
  echo "Skills (--skills):"
  for d in "$KIT/skills/agents"/*/; do echo "  $(basename "$d")"; done
  echo "Stacks (--stack):"; list_dir stacks
  echo "Design systems (--design-system):"; list_dir design-systems
}

TARGET="" NAME="" STACK="" DS="" WITH="" SKILLS="" DRY=0
while [ $# -gt 0 ]; do
  case "$1" in
    --list) list_all; exit 0 ;;
    --name) NAME="${2:?}"; shift 2 ;;
    --with) WITH="${WITH:+$WITH,}${2:?}"; shift 2 ;;
    --skills) SKILLS="${SKILLS:+$SKILLS,}${2:?}"; shift 2 ;;
    --stack) STACK="${2:?}"; shift 2 ;;
    --design-system) DS="${2:?}"; shift 2 ;;
    --dry-run) DRY=1; shift ;;
    -h|--help) usage; exit 0 ;;
    -*) echo "Unknown option: $1" >&2; usage >&2; exit 1 ;;
    *) [ -z "$TARGET" ] || { usage >&2; exit 1; }; TARGET="$1"; shift ;;
  esac
done
[ -n "$TARGET" ] || { usage >&2; exit 1; }

for p in $(echo "$WITH" | tr ',' ' '); do
  case "$p" in
    all) WITH="skills,graphify,workflow,docs" ;;
    skills|graphify|workflow|docs) ;;
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

# بدون انتخاب، چیزی نصب نمی‌شود؛ فقط گزینه‌ها نشان داده می‌شوند.
if [ -z "$WITH" ] && [ -z "$STACK" ] && [ -z "$DS" ]; then
  {
    echo "Nothing selected, nothing installed."
    echo "If you are an AI agent: show this list to the user, ask which items they want,"
    echo "and pass only those. Do not pick for them, and do not add a design system or a"
    echo "stack to a project that already has its own."
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
