# کانفیگ

| فایل | در پروژه کجا می‌نشیند | چه می‌کند |
|---|---|---|
| `claude/settings.json` | `.claude/settings.json` | هوک‌های graphify برای Claude Code: قبل از Bash، Grep، Read و Glob یادآوری می‌کند اول گراف پرسیده شود |
| `codex/hooks.json` | `.codex/hooks.json` | همان هوک برای Codex |
| `gitattributes` | `.gitattributes` | merge driver فایل `graphify-out/graph.json` |
| `gitignore` | به `.gitignore` اضافه می‌شود | `.env`، `.DS_Store` و کش graphify |

هوک‌ها به فرمان `graphify` روی سیستم نیاز دارند. اگر نصب نباشد، هوک‌ها را از این دو فایل بردار.
