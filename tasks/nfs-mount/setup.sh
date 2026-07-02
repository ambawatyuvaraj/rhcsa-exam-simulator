#!/usr/bin/env bash
dnf -y install nfs-utils >/dev/null 2>&1 || true
mkdir -p /exports/share2
echo hello > /exports/share2/README
grep -q /exports/share2 /etc/exports 2>/dev/null || \
  echo "/exports/share2 *(rw,sync,no_root_squash)" >> /etc/exports
systemctl enable --now nfs-server >/dev/null 2>&1
exportfs -ra >/dev/null 2>&1
umount "/mnt/$MP" 2>/dev/null
sed -i '\#/mnt/'"$MP"'#d' /etc/fstab 2>/dev/null
rm -rf "/mnt/$MP" 2>/dev/null
echo "nfs-mount: export localhost:/exports/share2 is available"
exit 0
