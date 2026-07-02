#!/usr/bin/env bash
. "$RHCSA_LIB/storage-prep.sh"
umount -lf "/mnt/$MP" 2>/dev/null
sed -i '\#/mnt/'"$MP"'#d' /etc/fstab 2>/dev/null
lvremove -f "$VG/$LV" >/dev/null 2>&1
vgremove -f "$VG" >/dev/null 2>&1
rm -rf "/mnt/$MP" 2>/dev/null
spare_cleanup
exit 0
