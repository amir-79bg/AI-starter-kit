# __PROJECT__

## روند کار

هر تسک طبق `docs/TASK_WORKFLOW.md` انجام می‌شود: فهمیدن خواسته، جهت‌یابی با graphify، پیاده‌سازی، تست، چک‌لیست امنیت، اعمال روی برنامهٔ در حال اجرا، به‌روز کردن گراف، گزارش.

## graphify

This project has a knowledge graph at graphify-out/ with god nodes, community structure, and cross-file relationships.

When the user types `/graphify`, use the installed graphify skill or instructions before doing anything else.

Rules:
- For codebase questions, first run `graphify query "<question>"` when graphify-out/graph.json exists. Use `graphify path "<A>" "<B>"` for relationships and `graphify explain "<concept>"` for focused concepts. These return a scoped subgraph, usually much smaller than GRAPH_REPORT.md or raw grep output.
- Dirty graphify-out/ files are expected after hooks or incremental updates; dirty graph files are not a reason to skip graphify. Only skip graphify if the task is about stale or incorrect graph output, or the user explicitly says not to use it.
- If graphify-out/wiki/index.md exists, use it for broad navigation instead of raw source browsing.
- Read graphify-out/GRAPH_REPORT.md only for broad architecture review or when query/path/explain do not surface enough context.
- After modifying code, run `graphify update .` to keep the graph current (AST-only, no API cost).

## چک‌لیست امنیت انتشار

- در توسعه هر فیچر جدید یا تغییر در احراز هویت، دسترسی‌ها، API، فایل یا داده حساس، `docs/SECURITY_RELEASE_CHECKLIST.md` را بررسی و موارد امنیت و تست مرتبط را اضافه یا به‌روز کنید.
- صرف پیاده‌سازی یا قبولی تست عملکرد، تأیید امنیت نیست؛ وضعیت «تأییدشده» فقط با تست اجراشده و مدرک نتیجه ثبت شود.
- پیش از انتشار عمومی، موارد حل‌نشده بحرانی/پرخطر و نتیجه تست امنیت را گزارش کنید. تغییر کنترل مرتبط، نیازمند تست مجدد است.
