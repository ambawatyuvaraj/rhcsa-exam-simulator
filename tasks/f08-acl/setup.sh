#!/usr/bin/env bash
rm -f /var/tmp/fstab 2>/dev/null
# harry/natasha normally come from the users/group task in the same paper. Seeded
# without it (category practice), create them so the ACL can name them.
if [ ! -f /run/rhcsa-sim/f08-users.active ] && [ ! -f /run/rhcsa-sim/users-groups.active ]; then
  for u in harry natasha; do id "$u" >/dev/null 2>&1 || useradd "$u"; done
fi
echo "f08-acl: ready"
exit 0
