#!/usr/bin/env bash
rm -f /etc/profile.d/rhcsa-umask.sh 2>/dev/null
# The grade also accepts (and solution.md documents) a login.defs-based answer.
# Restore the stock UMASK so a login.defs answer doesn't permanently contaminate
# /etc/login.defs and leak into later per-user umask tasks (f08-umask etc.).
sed -i 's/^[[:space:]]*UMASK.*/UMASK\t\t022/I' /etc/login.defs 2>/dev/null || true
exit 0
