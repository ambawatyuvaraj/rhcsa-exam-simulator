#!/usr/bin/env bash
# harry is created by the users task. If that task is in THIS session it sets a marker
# -> defer to it (let the candidate create harry). Standalone, create harry so this task
# is solvable on its own. Either way, clear any crontab so the baseline has no job.
[ -f /run/rhcsa-sim/users-groups.active ] || { id harry >/dev/null 2>&1 || useradd harry; }
crontab -r -u harry >/dev/null 2>&1
echo "e2-cron: ready (crontab cleared)"
exit 0
