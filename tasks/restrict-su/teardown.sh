#!/usr/bin/env bash
if [ -f /etc/pam.d/su.rhcsa-bak ]; then
  mv -f /etc/pam.d/su.rhcsa-bak /etc/pam.d/su
fi
exit 0
