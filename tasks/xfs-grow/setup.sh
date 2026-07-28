#!/usr/bin/env bash
. "$RHCSA_LIB/storage-prep.sh"
DEV="$(ensure_spare_disk)" || { echo "xfs-grow: could not provide a spare disk"; exit 1; }
P="${DEV}1"; [ -b "$P" ] || P="${DEV}p1"
if [ ! -b "$P" ]; then
  parted -s "$DEV" mklabel gpt >/dev/null 2>&1
  parted -s "$DEV" mkpart primary 1MiB 1536MiB >/dev/null 2>&1   # fits a 2GiB spare disk
  udevadm settle 2>/dev/null; sleep 1
  P="${DEV}1"; [ -b "$P" ] || P="${DEV}p1"
fi
if ! vgs "$VG" >/dev/null 2>&1; then
  pvcreate -ff -y "$P" >/dev/null 2>&1
  vgcreate "$VG" "$P" >/dev/null 2>&1
fi
if ! lvs "$VG/$LV" >/dev/null 2>&1; then
  # 320M, not 256M: RHEL 10 mkfs.xfs refuses any XFS below 300 MiB (RHEL 9 accepts either).
  lvcreate -y -L 320M -n "$LV" "$VG" >/dev/null 2>&1
  mkfs.xfs -f "/dev/$VG/$LV" >/dev/null 2>&1
fi
mkdir -p "/mnt/$MP"
mountpoint -q "/mnt/$MP" || mount "/dev/$VG/$LV" "/mnt/$MP" 2>/dev/null
echo "xfs-grow: $VG/$LV (320M XFS) mounted at /mnt/$MP"
exit 0
