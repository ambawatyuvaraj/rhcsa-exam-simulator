#!/usr/bin/env bash
dnf -y install at >/dev/null 2>&1 || true
id "$U" >/dev/null 2>&1 || useradd "$U"
# at.allow takes precedence over at.deny; remove it so deny applies.
[ -f /etc/at.allow ] && mv -f /etc/at.allow /etc/at.allow.rhcsabak 2>/dev/null
touch /etc/at.deny
sed -i "/^$U$/d" /etc/at.deny 2>/dev/null
echo "at-deny: user '$U' ready, at.deny present"
exit 0
