#!/usr/bin/env bash
if [ -f /etc/pam.d/su.rhcsa-bak ]; then
  mv -f /etc/pam.d/su.rhcsa-bak /etc/pam.d/su
fi
restorecon -F /etc/pam.d/su 2>/dev/null   # mv keeps the backup's label; put the file's own back
exit 0
