#!/usr/bin/env bash
. "$RHCSA_LIB/storage-prep.sh"
DEV="$(ensure_spare_disk)"
P="${DEV}1"; [ -b "$P" ] || P="${DEV}p1"
swapoff "$P" 2>/dev/null
sed -i '\#pri='"$PRI"'#d' /etc/fstab 2>/dev/null
spare_cleanup
exit 0
