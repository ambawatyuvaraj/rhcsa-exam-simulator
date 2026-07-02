#!/usr/bin/env bash
. "$RHCSA_LIB/storage-prep.sh"
DEV="$(ensure_spare_disk)"
P="${DEV}1"; [ -b "$P" ] || P="${DEV}p1"
umount -lf "/mnt/$MP" 2>/dev/null
sed -i '\#/mnt/'"$MP"'#d' /etc/fstab 2>/dev/null
rm -rf "/mnt/$MP" 2>/dev/null
vgremove -f "$VG" >/dev/null 2>&1
pvremove -ff -y "$P" >/dev/null 2>&1
spare_cleanup
exit 0
