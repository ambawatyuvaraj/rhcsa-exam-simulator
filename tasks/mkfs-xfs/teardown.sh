#!/usr/bin/env bash
. "$RHCSA_LIB/storage-prep.sh"
umount -lf "/mnt/$MP" 2>/dev/null
sed -i '\#/mnt/'"$MP"'#d' /etc/fstab 2>/dev/null
rm -rf "/mnt/$MP" 2>/dev/null
spare_cleanup
exit 0
