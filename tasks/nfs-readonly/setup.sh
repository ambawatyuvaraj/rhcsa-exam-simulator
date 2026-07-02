#!/usr/bin/env bash
dnf -y install nfs-utils >/dev/null 2>&1 || true
mkdir -p /exports/ro
echo hi >/exports/ro/f
grep -q "/exports/ro" /etc/exports 2>/dev/null || \
  echo "/exports/ro *(ro,sync)" >>/etc/exports
systemctl enable --now nfs-server >/dev/null 2>&1
exportfs -ra >/dev/null 2>&1
umount "/mnt/$MP" 2>/dev/null
sed -i '\#/mnt/'"$MP"'#d' /etc/fstab 2>/dev/null
rm -rf "/mnt/$MP" 2>/dev/null
echo "nfs-readonly: export localhost:/exports/ro ready"
exit 0
