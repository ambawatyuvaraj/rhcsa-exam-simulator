#!/usr/bin/env bash
# Create a labelled ext4 fs on the spare partition; mount by LABEL persistently.
. "$RHCSA_LIB/storage-prep.sh"; DEV="$(ensure_spare_disk)"
P="${DEV}1"; [ -b "$P" ] || P="${DEV}p1"
if [ ! -b "$P" ]; then
  parted -s "$DEV" mklabel gpt >/dev/null 2>&1
  parted -s "$DEV" mkpart primary 1MiB 513MiB >/dev/null 2>&1
  udevadm settle 2>/dev/null; sleep 1
  P="${DEV}1"; [ -b "$P" ] || P="${DEV}p1"
fi
# (Re)make ext4 with the label only if not already labelled correctly.
if [ "$(blkid -s TYPE -o value "$P" 2>/dev/null)" != ext4 ] || \
   [ "$(blkid -s LABEL -o value "$P" 2>/dev/null)" != "$LBL" ]; then
  mkfs.ext4 -F -L "$LBL" "$P" >/dev/null 2>&1
fi
mkdir -p "/mnt/$MP"
grep -vE '^\s*#' /etc/fstab | grep -q "/mnt/$MP" || \
  echo "LABEL=$LBL /mnt/$MP ext4 defaults,nofail 0 0" >>/etc/fstab
systemctl daemon-reload 2>/dev/null
mount "/mnt/$MP" 2>/dev/null || mount -a 2>/dev/null
