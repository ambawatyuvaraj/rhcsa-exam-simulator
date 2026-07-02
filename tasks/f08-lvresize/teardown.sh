#!/usr/bin/env bash
. "$RHCSA_LIB/storage-prep.sh"
umount -lf /mnt/wlogic 2>/dev/null
sed -i '\#/mnt/wlogic#d' /etc/fstab 2>/dev/null
lvremove -f wgroup >/dev/null 2>&1
vgremove -f wgroup >/dev/null 2>&1
rm -rf /mnt/wlogic 2>/dev/null
spare_cleanup
exit 0
