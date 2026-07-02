#!/usr/bin/env bash
. "$RHCSA_LIB/storage-prep.sh"
DEV="$(ensure_spare_disk)" || { echo "partition-resize: could not provide a spare disk"; exit 1; }
umount "/mnt/$MP" 2>/dev/null
sed -i '\#/mnt/'"$MP"'#d' /etc/fstab 2>/dev/null
# Fresh ~200 MiB partition leaving free space after it (disk is >=1GiB).
parted -s "$DEV" mklabel gpt 2>/dev/null
parted -s "$DEV" mkpart primary 1MiB 200MiB 2>/dev/null
udevadm settle 2>/dev/null; sleep 1
P="${DEV}1"; [ -b "$P" ] || P="${DEV}p1"
mkfs.ext4 -F "$P" >/dev/null 2>&1
mkdir -p "/mnt/$MP"
mount "$P" "/mnt/$MP" 2>/dev/null
echo "partition-resize: spare disk = $DEV (P1 ~200M ext4 at /mnt/$MP, free space follows)"
exit 0
