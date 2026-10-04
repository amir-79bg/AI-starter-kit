# AI Starter Kit

پایهٔ مشترک پروژه‌ها: هر پروژهٔ تازه از اینجا شروع می‌شود و هر چیزی که در یک پروژه ساخته شد و به درد بعدی‌ها می‌خورد، به اینجا برمی‌گردد.

## چه چیزی اینجاست

| پوشه | چیست |
|---|---|
| [`skills/`](skills/) | اسکیل‌های ایجنت |
| [`workflow/`](workflow/) | روند انجام یک تسک و قالب `AGENTS.md` |
| [`config/`](config/) | تنظیمات و هوک‌های Claude Code و Codex |
| [`docs-templates/`](docs-templates/) | قالب خام داکیومنت‌های پروژه |
| [`design-systems/`](design-systems/) | فهرست دیزاین سیستم‌ها؛ یکی برای هر پروژه انتخاب می‌شود |
| [`stacks/`](stacks/) | فهرست استک‌های فنی؛ اختیاری |
| [`bin/new-project.sh`](bin/new-project.sh) | ساخت پروژهٔ تازه از روی همهٔ این‌ها |

## شروع پروژهٔ تازه

```bash
bin/new-project.sh --list                                    # استک‌ها و دیزاین سیستم‌های موجود
bin/new-project.sh ../my-app                                 # فقط لایهٔ ایجنت
bin/new-project.sh ../my-app --stack django-next-docker --design-system dig
```

اسکریپت روی پروژهٔ موجود هم اجرا می‌شود و هیچ فایلی را بازنویسی نمی‌کند.

چیزی که در پروژه ساخته می‌شود:

```
my-app/
├── AGENTS.md              روند کار + قانون‌های استک و دیزاین سیستم انتخاب‌شده
├── CLAUDE.md              به AGENTS.md اشاره می‌کند
├── .agents/skills/        اسکیل‌های عمومی
├── .claude/               اسکیل graphify و هوک‌ها
├── .codex/                اسکیل graphify و هوک‌ها
├── docs/                  روند تسک، پلن محصول، نیازمندی‌ها و معماری، چک‌لیست امنیت
└── ...                    فایل‌های استک و دیزاین سیستم، اگر انتخاب شده باشند
```

بعد از آن، مرحله‌های مخصوص استک و دیزاین سیستم در `README.md` همان پوشه نوشته شده است.

## پیش‌نیاز

- [graphify](skills/claude/graphify/SKILL.md) روی سیستم نصب باشد؛ هوک‌ها و روند کار به آن تکیه دارند.
- برای استک و دیزاین سیستم: Docker و Node 20.

## اضافه کردن چیز تازه

| چه چیزی | کجا | راهنما |
|---|---|---|
| دیزاین سیستم | `design-systems/<id>/` | [design-systems/README.md](design-systems/README.md) |
| استک فنی | `stacks/<id>/` | [stacks/README.md](stacks/README.md) |
| اسکیل | `skills/agents/<name>/` | [skills/README.md](skills/README.md) |
| قانون تازه در روند کار | `workflow/TASK_WORKFLOW.md` | — |
| قالب داکیومنت | `docs-templates/` و یک خط `copy_file` در اسکریپت | — |
