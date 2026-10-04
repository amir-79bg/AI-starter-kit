# اسکیل‌ها

| پوشه | در پروژه کجا می‌نشیند | چه چیزی دارد |
|---|---|---|
| `agents/` | `.agents/skills/` | اسکیل‌های عمومی |
| `claude/` | `.claude/skills/` | نسخهٔ Claude Code از graphify |
| `codex/` | `.codex/skills/` | نسخهٔ Codex از graphify |
| `spec/` | `.agents/skills/` و `.claude/skills/` | مشخصات فیچر، پلن و رفع باگ؛ با `--with spec` |

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
| `doc-coauthoring` | روند نوشتن مستندات، پروپوزال و مشخصات فنی |
| `internal-comms` | نوشتن ارتباطات داخلی سازمان |
| `claude-api` | مرجع Claude API و SDK |
| `mcp-builder` | ساخت سرور MCP |
| `skill-creator` | ساخت، بهبود و ارزیابی اسکیل |
| `academy-guide` | پیشنهاد دوره و آموزش از Claude Academy |
| `discernment-nudge` | یادآوری بازبینی بعد از جوابی که کاربر ممکن است روی آن عمل کند |

## اسکیل‌های مشخصات و باگ

| اسکیل | کاربرد |
|---|---|
| `feature-spec` | مشخصات فیچر و پرسیدن ابهام‌ها قبل از کد |
| `feature-plan` | پلن فنی، تسک‌های مرتب، و تطبیق کد با مشخصات |
| `bug-fix` | رفع باگ در سه مرحله: تشخیص، رفع، تأیید |

این سه برای همین کیت نوشته شده‌اند و ایده‌شان از روند [Spec Kit](https://github.com/github/spec-kit) گرفته شده؛ متن یا فایلی از آن کپی نشده است.

## مجوز

اسکیل‌هایی که `LICENSE.txt` دارند با مجوز Apache 2.0 منتشر شده‌اند. `doc-coauthoring` فایل مجوز ندارد.

اسکیل‌های `docx`، `pdf`، `pptx` و `xlsx` در این ریپو نیستند، چون مجوزشان اجازهٔ توزیع نمی‌دهد. این چهار اسکیل از داخل خود Claude در دسترس‌اند. قبل از اضافه کردن هر اسکیل تازه، مجوزش را بخوان.

## اضافه کردن اسکیل تازه

پوشهٔ اسکیل (با `SKILL.md`) را در `agents/` بگذار و یک ردیف به جدول بالا اضافه کن. برای ساختن اسکیل از صفر، `skill-creator` را به کار بگیر.
