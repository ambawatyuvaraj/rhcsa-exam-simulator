#!/usr/bin/env bash
# Create an XFS fs on the spare partition; mount persistently by UUID.
. "$RHCSA_LIB/storage-prep.sh"; DEV="$(ensure_spare_disk)"
P="${DEV}1"; [ -b "$P" ] || P="${DEV}p1"
if [ ! -b "$P" ]; then
  parted -s "$DEV" mklabel gpt >/dev/null 2>&1
  parted -s "$DEV" mkpart primary 1MiB 513MiB >/dev/null 2>&1
  udevadm settle 2>/dev/null; sleep 1
  P="${DEV}1"; [ -b "$P" ] || P="${DEV}p1"
fi
[ "$(blkid -s TYPE -o value "$P" 2>/dev/null)" = xfs ] || mkfs.xfs -f "$P" >/dev/null 2>&1
U="$(blkid -s UUID -o value "$P")"
mkdir -p "/mnt/$MP"
grep -vE '^\s*#' /etc/fstab | grep -q "/mnt/$MP" || \
  echo "UUID=$U /mnt/$MP xfs defaults,nofail 0 0" >>/etc/fstab
systemctl daemon-reload 2>/dev/null
mount "/mnt/$MP" 2>/dev/null || mount -a 2>/dev/null
