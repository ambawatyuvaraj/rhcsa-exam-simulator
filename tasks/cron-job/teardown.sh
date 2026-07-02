#!/usr/bin/env bash
crontab -r -u operator >/dev/null 2>&1
# NEVER userdel the stock 'operator' account — its home is /root, so 'userdel -r' would
# target /root. Only remove operator if WE created it (home /home/operator).
[ "$(getent passwd operator 2>/dev/null | cut -d: -f6)" = /home/operator ] && userdel -rf operator >/dev/null 2>&1
exit 0
