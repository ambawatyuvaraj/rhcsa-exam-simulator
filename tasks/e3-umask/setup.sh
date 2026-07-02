#!/usr/bin/env bash
# natasha is created by the users task; defer to it when present (marker), else create
# here so this task is solvable standalone.
[ -f /run/rhcsa-sim/users-groups.active ] || { id "$U" >/dev/null 2>&1 || useradd "$U"; }
# Ensure a clean baseline umask. A login.defs-based answer to umask-systemwide
# (a documented, grade-accepted method) leaves UMASK in /etc/login.defs, which
# every fresh user inherits -> this task would grade full points before any
# work. Restore stock login.defs (022), drop any profile.d umask file, and
# strip leftover umask lines from the user's own dotfiles.
sed -i 's/^[[:space:]]*UMASK.*/UMASK\t\t022/I' /etc/login.defs 2>/dev/null || true
grep -qiE '^[[:space:]]*UMASK' /etc/login.defs 2>/dev/null || printf 'UMASK\t\t022\n' >> /etc/login.defs
rm -f /etc/profile.d/rhcsa-umask.sh 2>/dev/null
for f in /home/"$U"/.bashrc /home/"$U"/.bash_profile /home/"$U"/.profile; do
  [ -f "$f" ] && sed -i '/^[[:space:]]*umask\b/Id' "$f" 2>/dev/null
done
echo "umask-default: seeded $U"
exit 0
