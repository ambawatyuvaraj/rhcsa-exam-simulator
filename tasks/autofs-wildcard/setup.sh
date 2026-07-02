#!/usr/bin/env bash
dnf -y install autofs nfs-utils >/dev/null 2>&1 || true
mkdir -p /exports/homes/u1 /exports/homes/u2
echo hi >/exports/homes/u1/README
echo hi >/exports/homes/u2/README
grep -q "/exports/homes" /etc/exports 2>/dev/null || \
  echo "/exports/homes *(rw,sync,no_root_squash)" >>/etc/exports
systemctl enable --now nfs-server >/dev/null 2>&1
exportfs -ra >/dev/null 2>&1
rm -f /etc/auto.master.d/homes.autofs /etc/auto.homes 2>/dev/null
echo "autofs-wildcard: export localhost:/exports/homes ready"
exit 0
