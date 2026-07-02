#!/usr/bin/env bash
if [ -f /etc/security/faillock.conf ] && [ ! -f /etc/security/faillock.conf.rhcsa-bak ]; then
  cp -a /etc/security/faillock.conf /etc/security/faillock.conf.rhcsa-bak
fi
# Remove any existing deny= line so the candidate must add it.
sed -i -E '/^[[:space:]]*deny[[:space:]]*=/d' /etc/security/faillock.conf 2>/dev/null
echo "faillock-config: ready (target deny=$N)"
exit 0
