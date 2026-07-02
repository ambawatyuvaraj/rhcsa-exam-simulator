#!/usr/bin/env bash
# Discover the pre-formatted ext4 spare partition and mount it by UUID.
. "$RHCSA_LIB/storage-prep.sh"; DEV="$(ensure_spare_disk)"
P="${DEV}1"; [ -b "$P" ] || P="${DEV}p1"
U="$(blkid -s UUID -o value "$P")"
mkdir -p "/mnt/$MP"
grep -vE '^\s*#' /etc/fstab | grep -q "/mnt/$MP" || \
  echo "UUID=$U /mnt/$MP ext4 defaults,nofail 0 0" >>/etc/fstab
systemctl daemon-reload 2>/dev/null
mount "/mnt/$MP" 2>/dev/null || mount -a 2>/dev/null
