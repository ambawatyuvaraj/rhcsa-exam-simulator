#!/usr/bin/env bash
dnf -y install nfs-utils autofs >/dev/null 2>&1 || true
# Clean baseline: drop any leftover autofs map entries from a prior attempt so
# the candidate adds them FRESH and they never accumulate as duplicates in the
# shared /etc/auto.* files (this is the 3x-duplicate bug seen in practice).
sed -i '/^[[:space:]]*production5[[:space:]]/d' /etc/auto.misc 2>/dev/null
sed -i '\#^[[:space:]]*/localhome[[:space:]]#d' /etc/auto.master 2>/dev/null
rm -f /etc/auto.master.d/localhome.autofs /etc/auto.localhome 2>/dev/null
mkdir -p /exports/localhome/production5
id production5 >/dev/null 2>&1 || useradd -u 4101 -d /localhome/production5 -M production5 2>/dev/null
echo "hello from production5 home" >/exports/localhome/production5/README
chown -R production5:production5 /exports/localhome/production5
grep -q "/exports/localhome" /etc/exports 2>/dev/null || \
  echo "/exports/localhome *(rw,sync,no_root_squash)" >>/etc/exports
systemctl enable --now nfs-server >/dev/null 2>&1
exportfs -ra >/dev/null 2>&1
echo "e1-autofs: NFS export localhost:/exports/localhome ready"
exit 0
