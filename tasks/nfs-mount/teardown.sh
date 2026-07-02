#!/usr/bin/env bash
umount -lf "/mnt/$MP" 2>/dev/null
sed -i '\#/mnt/'"$MP"'#d' /etc/fstab 2>/dev/null
systemctl disable --now nfs-server >/dev/null 2>&1
sed -i '\#/exports/share2#d' /etc/exports 2>/dev/null
exportfs -ra >/dev/null 2>&1
rm -rf /exports/share2 "/mnt/$MP" 2>/dev/null
exit 0
