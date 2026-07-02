#!/usr/bin/env bash
umount -lf "/mnt/$MP" 2>/dev/null
sed -i '\#/mnt/'"$MP"'#d' /etc/fstab 2>/dev/null
rm -rf "/mnt/$MP" 2>/dev/null
rm -f "/root/$ISO.iso" 2>/dev/null
rm -rf /opt/isosrc 2>/dev/null
exit 0
