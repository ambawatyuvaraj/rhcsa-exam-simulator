#!/usr/bin/env bash
. "$RHCSA_LIB/storage-prep.sh"; DEV="$(ensure_spare_disk)"
P="${DEV}1"; [ -b "$P" ] || P="${DEV}p1"
mkdir -p "/mnt/$MP"
UUID="$(blkid -s UUID -o value "$P")"
grep -q "/mnt/$MP" /etc/fstab || \
  echo "UUID=$UUID /mnt/$MP ext4 defaults,nofail 0 0" >>/etc/fstab
mount -a 2>/dev/null
