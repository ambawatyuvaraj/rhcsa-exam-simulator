#!/usr/bin/env bash
. "$RHCSA_LIB/storage-prep.sh"
DEV="$(ensure_spare_disk)" || { echo "remount-ro: could not provide a spare disk"; exit 1; }
P="${DEV}1"; [ -b "$P" ] || P="${DEV}p1"
if [ ! -b "$P" ]; then
  parted -s "$DEV" mklabel gpt >/dev/null 2>&1
  parted -s "$DEV" mkpart primary 1MiB 513MiB >/dev/null 2>&1
  udevadm settle 2>/dev/null; sleep 1
  P="${DEV}1"; [ -b "$P" ] || P="${DEV}p1"
fi
blkid -o value -s TYPE "$P" 2>/dev/null | grep -q ext4 || mkfs.ext4 -F "$P" >/dev/null 2>&1
mkdir -p "/mnt/$MP"
if mountpoint -q "/mnt/$MP"; then
  mount -o remount,rw "/mnt/$MP" 2>/dev/null
else
  mount "$P" "/mnt/$MP" 2>/dev/null
fi
echo "remount-ro: $P mounted read-write at /mnt/$MP"
exit 0
