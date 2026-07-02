#!/usr/bin/env bash
dnf -y install nfs-utils autofs >/dev/null 2>&1 || true
mkdir -p /exports/rhome/remoteuser1
id remoteuser1 >/dev/null 2>&1 || useradd -u 4101 -d /rhome/remoteuser1 -M remoteuser1 2>/dev/null
echo "hello from remoteuser1 home" >/exports/rhome/remoteuser1/README
chown -R remoteuser1:remoteuser1 /exports/rhome/remoteuser1
grep -q "/exports/rhome" /etc/exports 2>/dev/null || \
  echo "/exports/rhome *(rw,sync,no_root_squash)" >>/etc/exports
systemctl enable --now nfs-server >/dev/null 2>&1
exportfs -ra >/dev/null 2>&1
echo "autofs-nfs: NFS export localhost:/exports/rhome ready"
exit 0
