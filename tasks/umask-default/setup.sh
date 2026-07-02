#!/usr/bin/env bash
id "$U" >/dev/null 2>&1 || useradd "$U"
# Clean baseline (see f08-umask/setup.sh): a login.defs-based umask-systemwide
# answer would otherwise leak its UMASK into this fresh user and pre-satisfy the
# task. Restore stock login.defs, drop profile.d umask, strip user dotfiles.
sed -i 's/^[[:space:]]*UMASK.*/UMASK\t\t022/I' /etc/login.defs 2>/dev/null || true
grep -qiE '^[[:space:]]*UMASK' /etc/login.defs 2>/dev/null || printf 'UMASK\t\t022\n' >> /etc/login.defs
rm -f /etc/profile.d/rhcsa-umask.sh 2>/dev/null
for f in /home/"$U"/.bashrc /home/"$U"/.bash_profile /home/"$U"/.profile; do
  [ -f "$f" ] && sed -i '/^[[:space:]]*umask\b/Id' "$f" 2>/dev/null
done
echo "umask-default: seeded $U"
exit 0
