#!/usr/bin/env bash
id "$U" >/dev/null 2>&1 || useradd "$U"
# cron.allow takes precedence over cron.deny; remove it so the deny file applies.
[ -f /etc/cron.allow ] && mv -f /etc/cron.allow /etc/cron.allow.rhcsabak 2>/dev/null
touch /etc/cron.deny
# ensure our user isn't already denied (don't do the candidate's work)
sed -i "/^$U$/d" /etc/cron.deny 2>/dev/null
echo "cron-deny: user '$U' ready, cron.deny present"
exit 0
