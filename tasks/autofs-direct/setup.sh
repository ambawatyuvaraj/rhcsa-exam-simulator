#!/usr/bin/env bash
dnf -y install autofs nfs-utils >/dev/null 2>&1 || true
mkdir -p /exports/direct
echo hi >/exports/direct/README
grep -q "/exports/direct" /etc/exports 2>/dev/null || \
  echo "/exports/direct *(rw,sync,no_root_squash)" >>/etc/exports
systemctl enable --now nfs-server >/dev/null 2>&1
exportfs -ra >/dev/null 2>&1
# Remove any candidate maps from prior attempts (do not do the work).
rm -f /etc/auto.master.d/direct.autofs /etc/auto.direct 2>/dev/null
echo "autofs-direct: export localhost:/exports/direct ready"
exit 0
