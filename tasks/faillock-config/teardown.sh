#!/usr/bin/env bash
if [ -f /etc/security/faillock.conf.rhcsa-bak ]; then
  mv -f /etc/security/faillock.conf.rhcsa-bak /etc/security/faillock.conf
else
  sed -i -E '/^[[:space:]]*deny[[:space:]]*=/d' /etc/security/faillock.conf 2>/dev/null
fi
exit 0
