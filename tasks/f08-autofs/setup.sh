#!/usr/bin/env bash
dnf -y install nfs-utils autofs >/dev/null 2>&1 || true
# Clean baseline: drop any leftover autofs map entries from a prior attempt so
# the candidate adds them FRESH and they never accumulate as duplicates in the
# shared /etc/auto.* files (this is the 3x-duplicate bug seen in practice).
sed -i '/^[[:space:]]*remoteuser1[[:space:]]/d' /etc/auto.misc 2>/dev/null
sed -i '\#^[[:space:]]*/rhome[[:space:]]#d' /etc/auto.master 2>/dev/null
rm -f /etc/auto.master.d/rhome.autofs /etc/auto.rhome 2>/dev/null
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
