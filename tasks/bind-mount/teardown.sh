#!/usr/bin/env bash
umount -lf "/mnt/$MP" 2>/dev/null
sed -i '\#/mnt/'"$MP"'#d' /etc/fstab 2>/dev/null
rm -rf "/mnt/$MP" "/srv/$SRC" 2>/dev/null
exit 0
