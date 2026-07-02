#!/usr/bin/env bash
# Troubleshooting fault (safe): remove NOPASSWD from the rule so members of the
# group are prompted for a password. The sudoers file stays syntactically valid,
# so general sudo access is NOT broken.
if [ -f /etc/sudoers.d/sysmgrs ]; then
  sed -i 's/[[:space:]]*NOPASSWD:[[:space:]]*/ /' /etc/sudoers.d/sysmgrs
  chmod 0440 /etc/sudoers.d/sysmgrs
else
  echo "%sysmgrs ALL=(ALL) ALL" >/etc/sudoers.d/sysmgrs; chmod 0440 /etc/sudoers.d/sysmgrs
fi
echo "SYMPTOM: members of group 'sysmgrs' are being asked for a password — the passwordless (NOPASSWD) sudo rule is broken"
