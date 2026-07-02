#!/usr/bin/env bash
. "$RHCSA_LIB/storage-prep.sh"
DEV="$(ensure_spare_disk)" || { echo "pv-move: could not provide a spare disk"; exit 1; }
vgremove -f "$VG" >/dev/null 2>&1 || true
parted -s "$DEV" mklabel gpt 2>/dev/null
parted -s "$DEV" mkpart primary 1MiB 600MiB 2>/dev/null
parted -s "$DEV" mkpart primary 600MiB 1200MiB 2>/dev/null
udevadm settle 2>/dev/null; sleep 1
P1="${DEV}1"; [ -b "$P1" ] || P1="${DEV}p1"
P2="${DEV}2"; [ -b "$P2" ] || P2="${DEV}p2"
pvcreate -ff -y "$P1" "$P2" >/dev/null 2>&1
vgcreate "$VG" "$P1" "$P2" >/dev/null 2>&1
# Place an LV with extents on the SECOND PV so a pvmove is actually required.
lvcreate -y -L 200M -n "$LV" "$VG" "$P2" >/dev/null 2>&1
mkfs.ext4 -F "/dev/$VG/$LV" >/dev/null 2>&1
echo "pv-move: spare disk = $DEV (VG $VG over two PVs, $LV on second PV)"
exit 0
