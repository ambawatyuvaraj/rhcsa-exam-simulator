#!/usr/bin/env bash
. "$RHCSA_LIB/storage-prep.sh"
DEV="$(ensure_spare_disk)" || { echo "label-mount: could not provide a spare disk"; exit 1; }
umount "/mnt/$MP" 2>/dev/null
sed -i '\#/mnt/'"$MP"'#d' /etc/fstab 2>/dev/null
rm -rf "/mnt/$MP" 2>/dev/null
P="${DEV}1"; [ -b "$P" ] || P="${DEV}p1"
if [ ! -b "$P" ]; then
  parted -s "$DEV" mklabel gpt >/dev/null 2>&1
  parted -s "$DEV" mkpart primary 1MiB 513MiB >/dev/null 2>&1
  udevadm settle 2>/dev/null; sleep 1
  P="${DEV}1"; [ -b "$P" ] || P="${DEV}p1"
fi
if [ "$(blkid -o value -s LABEL "$P" 2>/dev/null)" != "$LBL" ]; then
  mkfs.ext4 -F -L "$LBL" "$P" >/dev/null 2>&1
fi
echo "label-mount: ext4 filesystem labelled $LBL ready on $P"
exit 0
