#!/usr/bin/env bash
. "$RHCSA_LIB/storage-prep.sh"
DEV="$(ensure_spare_disk)" || { echo "lv-create-bysize: could not provide a spare disk"; exit 1; }
umount "/mnt/$MP" 2>/dev/null
sed -i '\#/mnt/'"$MP"'#d' /etc/fstab 2>/dev/null
rm -rf "/mnt/$MP" 2>/dev/null
vgremove -f "$VG" >/dev/null 2>&1 || true
if ! vgs "$VG" >/dev/null 2>&1; then
  parted -s "$DEV" mklabel gpt 2>/dev/null
  parted -s "$DEV" mkpart primary 1MiB 1024MiB 2>/dev/null
  udevadm settle 2>/dev/null; sleep 1
  P="${DEV}1"; [ -b "$P" ] || P="${DEV}p1"
  pvcreate -ff -y "$P" >/dev/null 2>&1
  vgcreate "$VG" "$P" >/dev/null 2>&1
fi
echo "lv-create-bysize: spare disk = $DEV (VG $VG ready)"
exit 0
