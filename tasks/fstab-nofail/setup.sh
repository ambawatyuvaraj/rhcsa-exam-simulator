#!/usr/bin/env bash
. "$RHCSA_LIB/storage-prep.sh"
DEV="$(ensure_spare_disk)" || { echo "fstab-nofail: could not provide a spare disk"; exit 1; }
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
blkid -o value -s TYPE "$P" 2>/dev/null | grep -q ext4 || mkfs.ext4 -F "$P" >/dev/null 2>&1
echo "fstab-nofail: ext4 filesystem ready on $P"
exit 0
