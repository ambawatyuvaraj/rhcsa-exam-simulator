#!/usr/bin/env bash
. "$RHCSA_LIB/storage-prep.sh"
mount -o remount,rw "/mnt/$MP" 2>/dev/null
umount -lf "/mnt/$MP" 2>/dev/null
rm -rf "/mnt/$MP" 2>/dev/null
spare_cleanup
exit 0
