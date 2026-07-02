#!/usr/bin/env bash
# Seed the user; the candidate writes the sudoers rule.
id "$U" >/dev/null 2>&1 || useradd "$U"
rm -f "/etc/sudoers.d/$U" 2>/dev/null
echo "sudo-user-cmd: seeded $U"
exit 0
