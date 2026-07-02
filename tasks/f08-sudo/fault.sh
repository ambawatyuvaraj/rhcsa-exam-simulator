#!/usr/bin/env bash
# Troubleshooting fault (safe): remove NOPASSWD from the rule so members of the
# group are prompted for a password. The sudoers file stays syntactically valid,
# so general sudo access is NOT broken.
if [ -f /etc/sudoers.d/admin ]; then
  sed -i 's/[[:space:]]*NOPASSWD:[[:space:]]*/ /' /etc/sudoers.d/admin
  chmod 0440 /etc/sudoers.d/admin
else
  echo "%admin ALL=(ALL) ALL" >/etc/sudoers.d/admin; chmod 0440 /etc/sudoers.d/admin
fi
echo "SYMPTOM: members of group 'admin' are being asked for a password — the passwordless (NOPASSWD) sudo rule is broken"
