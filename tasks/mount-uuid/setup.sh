#!/usr/bin/env bash
. "$RHCSA_LIB/storage-prep.sh"
DEV="$(ensure_spare_disk)" || { echo "mount-uuid: could not provide a spare disk"; exit 1; }
# Provide ONE pre-formatted ext4 partition (with a UUID) that the candidate must
# discover and mount by UUID. Do NOT mount it or touch fstab.
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
mkfs.ext4 -F "$P" >/dev/null 2>&1
echo "mount-uuid: prepared formatted ext4 partition $P on $DEV"
exit 0
