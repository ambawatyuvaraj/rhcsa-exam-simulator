#!/usr/bin/env bash
. "$RHCSA_LIB/storage-prep.sh"
umount -lf /mnt/vo 2>/dev/null
sed -i '\#/mnt/vo#d' /etc/fstab 2>/dev/null
lvremove -f vgroup >/dev/null 2>&1
vgremove -f vgroup >/dev/null 2>&1
rm -rf /mnt/vo 2>/dev/null
spare_cleanup
exit 0
