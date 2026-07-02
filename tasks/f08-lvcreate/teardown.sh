#!/usr/bin/env bash
. "$RHCSA_LIB/storage-prep.sh"
umount -lf /mnt/wshare 2>/dev/null
sed -i '\#/mnt/wshare#d' /etc/fstab 2>/dev/null
lvremove -f wgroup >/dev/null 2>&1
vgremove -f wgroup >/dev/null 2>&1
rm -rf /mnt/wshare 2>/dev/null
spare_cleanup
exit 0
