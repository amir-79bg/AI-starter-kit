# AI Starter Kit: قالب شروع پروژه با Claude Code و Codex

**AI Starter Kit** is a project template for AI-assisted development with **Claude Code** and **OpenAI Codex**. It bundles agent skills, an `AGENTS.md` / `CLAUDE.md` template, a step-by-step task workflow, hooks, documentation templates, a design-system registry (RTL / Persian admin panels) and an optional **Django + Next.js + Docker** boilerplate. One script scaffolds a new project from the parts you pick; nothing is installed unless it is named.

استارتر کیت هوش مصنوعی یک قالب آماده برای شروع پروژه با ایجنت‌های کدنویسی است. به‌جای اینکه در هر پروژه اسکیل‌ها، قانون‌های ایجنت، داکیومنت‌ها و دیزاین سیستم را از صفر بچینی، یک فرمان هر بخشی را که انتخاب کنی در پروژه می‌گذارد.

## فهرست

- [چه چیزی در این قالب هست](#چه-چیزی-در-این-قالب-هست)
- [شروع سریع](#شروع-سریع)
- [اگر ایجنت نصب می‌کند](#اگر-ایجنت-نصب-می‌کند)
- [روند انجام تسک برای ایجنت](#روند-انجام-تسک-برای-ایجنت)
- [دیزاین سیستم برای توسعهٔ پنل](#دیزاین-سیستم-برای-توسعهٔ-پنل)
- [استک فنی: Django + Next.js + Docker](#استک-فنی-django--nextjs--docker)
- [اضافه کردن اسکیل، دیزاین سیستم یا استک تازه](#اضافه-کردن-اسکیل-دیزاین-سیستم-یا-استک-تازه)
- [پیش‌نیاز](#پیش‌نیاز)

## چه چیزی در این قالب هست

| پوشه | چیست |
|---|---|
| [`skills/`](skills/) | ۱۵ اسکیل ایجنت (Agent Skills) برای طراحی رابط، تست اپ وب، ساخت آرتیفکت و تم، نوشتن مستندات، ساخت سرور MCP و کار با Claude API، به‌علاوهٔ اسکیل graphify برای گراف دانش کد |
| [`workflow/`](workflow/) | روند انجام تسک در ۹ مرحله و قالب `AGENTS.md` |
| [`config/`](config/) | تنظیمات و هوک‌های Claude Code (`.claude/settings.json`) و Codex (`.codex/hooks.json`) |
| [`docs-templates/`](docs-templates/) | قالب پلن محصول، سند نیازمندی‌ها و معماری، چک‌لیست امنیت قبل از انتشار و README |
| [`design-systems/`](design-systems/) | فهرست دیزاین سیستم‌ها؛ اختیاری، فقط وقتی کاربر خودش بخواهد |
| [`stacks/`](stacks/) | فهرست استک‌های فنی (boilerplate)؛ اختیاری |
| [`bin/new-project.sh`](bin/new-project.sh) | اسکریپت ساخت پروژهٔ تازه |

## شروع سریع

```bash
git clone https://github.com/amir-79bg/AI-starter-kit.git
cd AI-starter-kit

bin/new-project.sh --list                                    # بخش‌ها، اسکیل‌ها، استک‌ها و دیزاین سیستم‌ها
bin/new-project.sh ../my-app --with graphify,workflow --dry-run   # فقط نشان می‌دهد چه چیزی ساخته می‌شود
bin/new-project.sh ../my-app --with graphify,workflow --skills webapp-testing,frontend-design
bin/new-project.sh ../my-app --with all --stack django-next-docker
```

هیچ چیزی پیش‌فرض نصب نمی‌شود. اسکریپت بدون انتخاب فقط فهرست گزینه‌ها را چاپ می‌کند و به پروژه دست نمی‌زند.

| گزینه | چه چیزی نصب می‌کند |
|---|---|
| `--with skills` | همهٔ اسکیل‌های عمومی در `.agents/skills/` |
| `--skills a,b` | فقط اسکیل‌های نام‌برده، به‌جای همه |
| `--with graphify` | اسکیل graphify، هوک‌های Claude Code و Codex، `.gitattributes` |
| `--with workflow` | `AGENTS.md`، `CLAUDE.md`، `docs/TASK_WORKFLOW.md` و خط‌های پایهٔ `.gitignore` |
| `--with docs` | قالب پلن محصول، نیازمندی‌ها و معماری، چک‌لیست امنیت و README |
| `--with all` | چهار بخش بالا؛ استک و دیزاین سیستم را شامل نمی‌شود |
| `--stack <id>` | اسکلت فنی |
| `--design-system <id>` | دیزاین سیستم |
| `--dry-run` | چیزی نمی‌نویسد؛ فقط فهرست فایل‌هایی که ساخته می‌شوند |

اسکریپت روی پروژهٔ موجود هم اجرا می‌شود و هیچ فایلی را بازنویسی نمی‌کند. اگر `AGENTS.md` از قبل باشد، قانون‌های استک و دیزاین سیستم به آن اضافه نمی‌شوند و اسکریپت مسیرشان را می‌گوید تا دستی اضافه شوند.

## اگر ایجنت نصب می‌کند

این بخش برای Claude Code، Codex و هر ایجنت دیگری است که این کیت را روی پروژه‌ای نصب می‌کند.

1. اول `bin/new-project.sh --list` را اجرا کن و فهرست را به کاربر نشان بده.
2. از کاربر بپرس کدام بخش‌ها، کدام اسکیل‌ها، و آیا استک یا دیزاین سیستم می‌خواهد. خودت به‌جای او انتخاب نکن و `--with all` را بدون اینکه خودش گفته باشد نزن.
3. دیزاین سیستم و استک را فقط وقتی نصب کن که کاربر صریح خواسته باشد. روی پروژه‌ای که رابط کاربری یا دیزاین سیستم خودش را دارد، دیزاین سیستم نصب نکن.
4. قبل از نصب واقعی، همان فرمان را با `--dry-run` اجرا کن و خروجی را به کاربر نشان بده. بعد از تأیید او بدون `--dry-run` اجرا کن.
5. بعد از نصب، فایل‌های موجود پروژه را به‌خاطر کیت تغییر نده؛ اگر چیزی باید دستی اضافه شود، به کاربر بگو.

ساختاری که با همهٔ بخش‌ها در پروژه ساخته می‌شود (اول هر خط نام بخش آمده):

```
my-app/
├── AGENTS.md              workflow: روند کار + قانون‌های استک و دیزاین سیستم انتخاب‌شده
├── CLAUDE.md              workflow: به AGENTS.md اشاره می‌کند
├── .agents/skills/        skills: اسکیل‌های عمومی
├── .claude/               graphify: اسکیل graphify و هوک‌های Claude Code
├── .codex/                graphify: اسکیل graphify و هوک‌های Codex
├── docs/                  workflow و docs: روند تسک، پلن محصول، نیازمندی‌ها و معماری، چک‌لیست امنیت
└── ...                    فایل‌های استک و دیزاین سیستم، اگر انتخاب شده باشند
```

مرحله‌های بعدیِ مخصوص هر استک و دیزاین سیستم در `README.md` همان پوشه نوشته شده است.

## روند انجام تسک برای ایجنت

ایجنت هر تسک را با همین ترتیب جلو می‌برد. متن کامل در [`workflow/TASK_WORKFLOW.md`](workflow/TASK_WORKFLOW.md) است.

1. فهمیدن خواسته و نگاه به پلن محصول
2. جهت‌یابی در کد با گراف دانش (graphify) قبل از grep
3. پیاده‌سازی با کامپوننت‌های دیزاین سیستم
4. تست، و دیدن تغییر در مرورگر
5. دادهٔ نمونه برای همهٔ حالت‌ها: خالی، یک مورد، تعداد زیاد، هر وضعیت، هر نقش
6. به‌روز کردن چک‌لیست امنیت
7. اعمال تغییر روی برنامهٔ در حال اجرا
8. به‌روز کردن گراف
9. گزارش: چه چیزی عوض شد، چه چیزی تست شد، چه چیزی نشد

## دیزاین سیستم برای توسعهٔ پنل

دیزاین سیستم اختیاری است و فقط با `--design-system <id>` نصب می‌شود. فهرست کامل در [`design-systems/`](design-systems/) است و با هر پروژه بزرگ‌تر می‌شود.

| شناسه | نام | مناسب برای |
|---|---|---|
| [`dig`](design-systems/dig/) | دیگ (Dig) | توسعهٔ پنل: پنل مدیریت، داشبورد و پنل کاربری فارسی و راست‌به‌چپ (RTL) با React و Tailwind CSS 4 |

دیگ بیشتر مناسب پنل است: فرم، جدول، سایدبار، دیالوگ و فیلدهای فارسی مثل تاریخ شمسی. برای لندینگ و صفحهٔ بازاریابی انتخاب اول نیست.

## استک فنی: Django + Next.js + Docker

فهرست کامل در [`stacks/`](stacks/) است.

| شناسه | بک‌اند | فرانت‌اند | زیرساخت |
|---|---|---|---|
| [`django-next-docker`](stacks/django-next-docker/) | Django 5، Django Ninja، Celery | Next.js 16، React 19، TypeScript، Tailwind CSS 4 | PostgreSQL، Redis، MinIO، Docker Compose |

این استک فقط اسکلت است: Dockerfileها، تنظیمات Django، یک مسیر `/health` و یک صفحهٔ خالی Next.js. مدل کاربر، ورود و منطق کسب‌وکار ندارد.

## اضافه کردن اسکیل، دیزاین سیستم یا استک تازه

| چه چیزی | کجا | راهنما |
|---|---|---|
| دیزاین سیستم | `design-systems/<id>/` | [design-systems/README.md](design-systems/README.md) |
| استک فنی | `stacks/<id>/` | [stacks/README.md](stacks/README.md) |
| اسکیل | `skills/agents/<name>/` | [skills/README.md](skills/README.md) |
| قانون تازه در روند کار | `workflow/TASK_WORKFLOW.md` | — |
| قالب داکیومنت | `docs-templates/` و یک خط `copy_file` در اسکریپت | — |

## پیش‌نیاز

- [graphify](skills/claude/graphify/SKILL.md) روی سیستم نصب باشد؛ هوک‌ها و روند کار به آن تکیه دارند.
- برای استک و دیزاین سیستم: Docker و Node 20.
- macOS یا Linux با bash.

## مجوز اسکیل‌ها

اسکیل‌ها با مجوز Apache 2.0 منتشر شده‌اند و هر کدام `LICENSE.txt` خودش را دارد؛ جزئیات در [skills/README.md](skills/README.md).
