#!/usr/bin/env bash
for u in harry natasha sarah; do
  id "$u" >/dev/null 2>&1 && userdel -rf "$u" >/dev/null 2>&1
done
getent group sysmgrs >/dev/null 2>&1 && groupdel sysmgrs >/dev/null 2>&1
rm -f /run/rhcsa-sim/users-groups.active 2>/dev/null
exit 0
