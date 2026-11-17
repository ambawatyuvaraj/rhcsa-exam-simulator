#!/usr/bin/env bash
# natasha normally comes from the users/group task in the same paper. Seeded
# without it (category practice), create her so the cron job has an owner.
if [ ! -f /run/rhcsa-sim/f08-users.active ] && [ ! -f /run/rhcsa-sim/users-groups.active ]; then
  id natasha >/dev/null 2>&1 || useradd natasha
fi
id natasha >/dev/null 2>&1 && crontab -r -u natasha >/dev/null 2>&1
echo "f08-cron: ready"
exit 0
