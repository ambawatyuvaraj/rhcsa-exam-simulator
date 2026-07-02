#!/usr/bin/env bash
. "$RHCSA_LIB/storage-prep.sh"
DEV="$(ensure_spare_disk)" || { echo "vg-extend: could not provide a spare disk"; exit 1; }
vgremove -f "$VG" >/dev/null 2>&1 || true
# Seed a VG with a single PV on the first partition (candidate adds the second).
if ! vgs "$VG" >/dev/null 2>&1; then
  parted -s "$DEV" mklabel gpt 2>/dev/null
  parted -s "$DEV" mkpart primary 1MiB 300MiB 2>/dev/null
  udevadm settle 2>/dev/null; sleep 1
  P1="${DEV}1"; [ -b "$P1" ] || P1="${DEV}p1"
  pvcreate -ff -y "$P1" >/dev/null 2>&1
  vgcreate "$VG" "$P1" >/dev/null 2>&1
fi
echo "vg-extend: spare disk = $DEV (VG $VG seeded with one PV)"
exit 0
