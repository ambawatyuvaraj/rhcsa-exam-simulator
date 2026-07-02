#!/usr/bin/env bash
. "$RHCSA_LIB/storage-prep.sh"; DEV="$(ensure_spare_disk)"
parted -s "$DEV" mklabel gpt 2>/dev/null
parted -s "$DEV" mkpart primary 1MiB $((SZ+30))MiB 2>/dev/null; udevadm settle 2>/dev/null; sleep 1
P="${DEV}1"; [ -b "$P" ] || P="${DEV}p1"
mkfs.ext4 -F "$P" >/dev/null 2>&1; mkdir -p /mnt/$MP
grep -q "/mnt/$MP" /etc/fstab || echo "$P /mnt/$MP ext4 defaults,nofail 0 0" >>/etc/fstab; mount -a 2>/dev/null
