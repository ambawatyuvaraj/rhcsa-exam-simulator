#!/usr/bin/env bash
for u in natasha harry sarah; do
  id "$u" >/dev/null 2>&1 && userdel -rf "$u" >/dev/null 2>&1
done
getent group manager >/dev/null 2>&1 && groupdel manager >/dev/null 2>&1
rm -f /run/rhcsa-sim/f08-users.active 2>/dev/null
exit 0
