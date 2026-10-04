#!/usr/bin/env bash
# یک پروژهٔ تازه از روی استارتر کیت می‌سازد.
set -euo pipefail

KIT="$(cd "$(dirname "$0")/.." && pwd)"

usage() {
  cat <<USAGE
Usage: bin/new-project.sh <target-dir> [--name <slug>] [--stack <id>] [--design-system <id>]
       bin/new-project.sh --list

  --name            project slug (default: target dir name, lowercased)
  --stack           one of stacks/ (optional)
  --design-system   one of design-systems/ (optional)
  --list            show available stacks and design systems

Existing files in <target-dir> are never overwritten.
USAGE
}

list_dir() {
  for d in "$KIT/$1"/*/; do
    id="$(basename "$d")"
    [ "$id" = "_template" ] && continue
    printf "  %-22s %s\n" "$id" "$(head -n 1 "$d/README.md" | sed 's/^# *//')"
  done
}

TARGET="" NAME="" STACK="" DS=""
while [ $# -gt 0 ]; do
  case "$1" in
    --list) echo "Stacks:"; list_dir stacks; echo "Design systems:"; list_dir design-systems; exit 0 ;;
    --name) NAME="${2:?}"; shift 2 ;;
    --stack) STACK="${2:?}"; shift 2 ;;
    --design-system) DS="${2:?}"; shift 2 ;;
    -h|--help) usage; exit 0 ;;
    -*) echo "Unknown option: $1" >&2; usage >&2; exit 1 ;;
    *) [ -z "$TARGET" ] || { usage >&2; exit 1; }; TARGET="$1"; shift ;;
  esac
done
[ -n "$TARGET" ] || { usage >&2; exit 1; }

if [ -n "$STACK" ] && { [ "$STACK" = "_template" ] || [ ! -d "$KIT/stacks/$STACK" ]; }; then
  echo "Unknown stack: $STACK" >&2; list_dir stacks >&2; exit 1
fi
if [ -n "$DS" ] && { [ "$DS" = "_template" ] || [ ! -d "$KIT/design-systems/$DS" ]; }; then
  echo "Unknown design system: $DS" >&2; list_dir design-systems >&2; exit 1
fi

mkdir -p "$TARGET"
TARGET="$(cd "$TARGET" && pwd)"
if [ -z "$NAME" ]; then
  NAME="$(basename "$TARGET" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9_]/_/g')"
fi
case "$NAME" in
  ""|*[!a-z0-9_]*) echo "Project name must be lowercase letters, digits or underscores: $NAME" >&2; exit 1 ;;
esac

NEW_FILES="$(mktemp)"
trap 'rm -f "$NEW_FILES"' EXIT

# یک فایل را فقط وقتی کپی می‌کند که در مقصد نباشد.
copy_file() {
  if [ -e "$2" ]; then
    echo "  skip (exists): ${2#"$TARGET"/}"
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
copy_skills() {
  mkdir -p "$2"
  for s in "$1"/*/; do
    id="$(basename "$s")"
    if [ -e "$2/$id" ]; then echo "  skip (exists): ${2#"$TARGET"/}/$id"; else cp -Rp "$s" "$2/$id"; fi
  done
}

echo "Agent layer"
copy_skills "$KIT/skills/agents" "$TARGET/.agents/skills"
copy_skills "$KIT/skills/claude" "$TARGET/.claude/skills"
copy_skills "$KIT/skills/codex" "$TARGET/.codex/skills"
copy_file "$KIT/config/claude/settings.json" "$TARGET/.claude/settings.json"
copy_file "$KIT/config/codex/hooks.json" "$TARGET/.codex/hooks.json"
copy_file "$KIT/config/gitattributes" "$TARGET/.gitattributes"
copy_file "$KIT/workflow/TASK_WORKFLOW.md" "$TARGET/docs/TASK_WORKFLOW.md"
copy_file "$KIT/docs-templates/PRODUCT_PLAN.md" "$TARGET/docs/PRODUCT_PLAN.md"
copy_file "$KIT/docs-templates/REQUIREMENTS_ARCHITECTURE.md" "$TARGET/docs/REQUIREMENTS_ARCHITECTURE.md"
copy_file "$KIT/docs-templates/SECURITY_RELEASE_CHECKLIST.md" "$TARGET/docs/SECURITY_RELEASE_CHECKLIST.md"
copy_file "$KIT/docs-templates/README.md" "$TARGET/README.md"

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
  copy_tree "$KIT/design-systems/$DS/files" "$TARGET/${FRONTEND_DIR:-.}"
fi

# .gitignore: خط‌های پایه اگر نیستند اضافه می‌شوند.
touch "$TARGET/.gitignore"
while IFS= read -r line; do
  grep -qxF "$line" "$TARGET/.gitignore" || echo "$line" >> "$TARGET/.gitignore"
done < "$KIT/config/gitignore"

# AGENTS.md: قالب پایه به‌علاوهٔ قانون‌های استک و دیزاین سیستم انتخاب‌شده.
if [ -e "$TARGET/AGENTS.md" ]; then
  echo "  skip (exists): AGENTS.md"
else
  {
    cat "$KIT/workflow/AGENTS.template.md"
    if [ -n "$STACK" ] && [ -f "$KIT/stacks/$STACK/AGENT_RULES.md" ]; then echo; cat "$KIT/stacks/$STACK/AGENT_RULES.md"; fi
    if [ -n "$DS" ] && [ -f "$KIT/design-systems/$DS/AGENT_RULES.md" ]; then echo; cat "$KIT/design-systems/$DS/AGENT_RULES.md"; fi
  } > "$TARGET/AGENTS.md"
  echo "$TARGET/AGENTS.md" >> "$NEW_FILES"
fi
[ -e "$TARGET/CLAUDE.md" ] || echo "@AGENTS.md" > "$TARGET/CLAUDE.md"

# نام پروژه فقط در فایل‌هایی که همین حالا ساخته شدند جایگزین می‌شود.
while IFS= read -r f; do
  if grep -q "__PROJECT__" "$f" 2>/dev/null; then
    NAME="$NAME" perl -pi -e 's/__PROJECT__/$ENV{NAME}/g' "$f"
  fi
done < "$NEW_FILES"

echo
echo "Done: $TARGET (name: $NAME)"
[ -n "$STACK" ] && echo "Next steps for the stack:         $KIT/stacks/$STACK/README.md"
[ -n "$DS" ] && echo "Next steps for the design system: $KIT/design-systems/$DS/README.md"
echo "Then: git init && graphify update ."
