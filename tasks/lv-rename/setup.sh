#!/usr/bin/env bash
. "$RHCSA_LIB/storage-prep.sh"
DEV="$(ensure_spare_disk)" || { echo "lv-rename: could not provide a spare disk"; exit 1; }
vgremove -f "$VG" >/dev/null 2>&1 || true
parted -s "$DEV" mklabel gpt 2>/dev/null
parted -s "$DEV" mkpart primary 1MiB 1024MiB 2>/dev/null
udevadm settle 2>/dev/null; sleep 1
P="${DEV}1"; [ -b "$P" ] || P="${DEV}p1"
pvcreate -ff -y "$P" >/dev/null 2>&1
vgcreate "$VG" "$P" >/dev/null 2>&1
lvcreate -y -L 200M -n "$OLD" "$VG" >/dev/null 2>&1
echo "lv-rename: spare disk = $DEV (VG $VG, LV $OLD created)"
exit 0
