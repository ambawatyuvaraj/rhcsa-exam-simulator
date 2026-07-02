#!/usr/bin/env bash
if [ -f /etc/pam.d/su ] && [ ! -f /etc/pam.d/su.rhcsa-bak ]; then
  cp -a /etc/pam.d/su /etc/pam.d/su.rhcsa-bak
fi
# Ensure the pam_wheel line is commented/absent so the candidate must enable it.
sed -i -E 's|^[[:space:]]*(auth[[:space:]]+required[[:space:]]+pam_wheel\.so.*)|#\1|' /etc/pam.d/su 2>/dev/null
echo "restrict-su: ready"
exit 0
