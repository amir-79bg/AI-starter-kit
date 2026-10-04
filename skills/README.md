# اسکیل‌ها

| پوشه | در پروژه کجا می‌نشیند | چه چیزی دارد |
|---|---|---|
| `agents/` | `.agents/skills/` | اسکیل‌های عمومی |
| `claude/` | `.claude/skills/` | نسخهٔ Claude Code از graphify |
| `codex/` | `.codex/skills/` | نسخهٔ Codex از graphify |

دو نسخهٔ graphify را خود graphify برای هر ابزار جدا می‌سازد و محتوایشان فرق دارد؛ برای همین جدا نگه داشته شده‌اند (نسخهٔ 0.9.72).

## اسکیل‌های عمومی

| اسکیل | کاربرد |
|---|---|
| `frontend-design` | جهت بصری، تایپوگرافی و چیدمان هنگام ساخت رابط |
| `webapp-testing` | تست و دیباگ اپ وب محلی با Playwright |
| `web-artifacts-builder` | ساخت آرتیفکت HTML چندکامپوننتی با React و Tailwind |
| `theme-factory` | تم آماده برای اسلاید، سند و صفحهٔ HTML |
| `canvas-design` | پوستر و طرح بصری در PNG و PDF |
| `algorithmic-art` | هنر الگوریتمی با p5.js |
| `brand-guidelines` | رنگ و تایپوگرافی برند Anthropic |
| `slack-gif-creator` | GIF متحرک برای Slack |
| `docx` · `pdf` · `pptx` · `xlsx` | ساخت و ویرایش فایل‌های Word، PDF، PowerPoint و Excel |
| `doc-coauthoring` | روند نوشتن مستندات، پروپوزال و مشخصات فنی |
| `internal-comms` | نوشتن ارتباطات داخلی سازمان |
| `claude-api` | مرجع Claude API و SDK |
| `mcp-builder` | ساخت سرور MCP |
| `skill-creator` | ساخت، بهبود و ارزیابی اسکیل |
| `academy-guide` | پیشنهاد دوره و آموزش از Claude Academy |
| `discernment-nudge` | یادآوری بازبینی بعد از جوابی که کاربر ممکن است روی آن عمل کند |

هر اسکیل مجوز خودش را در `LICENSE.txt` همان پوشه دارد.

## اضافه کردن اسکیل تازه

پوشهٔ اسکیل (با `SKILL.md`) را در `agents/` بگذار و یک ردیف به جدول بالا اضافه کن. برای ساختن اسکیل از صفر، `skill-creator` را به کار بگیر.
