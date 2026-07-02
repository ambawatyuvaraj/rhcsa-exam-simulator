#!/usr/bin/env bash
. "$RHCSA_LIB/storage-prep.sh"
umount -lf /mnt/lvext 2>/dev/null
sed -i '\#/mnt/lvext#d' /etc/fstab 2>/dev/null
lvremove -f vgext >/dev/null 2>&1
vgremove -f vgext >/dev/null 2>&1
rm -rf /mnt/lvext 2>/dev/null
spare_cleanup
exit 0
