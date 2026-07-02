#!/usr/bin/env bash
. "$RHCSA_LIB/storage-prep.sh"
DEV="$(ensure_spare_disk)" || { echo "lvm-extend: could not provide a spare disk"; exit 1; }
# Build the pre-existing vgext/lvext (256 MiB ext4) mounted at /mnt/lvext.
if ! vgs vgext >/dev/null 2>&1; then
  P="${DEV}1"; [ -b "$P" ] || P="${DEV}p1"
  if [ ! -b "$P" ]; then
    parted -s "$DEV" mklabel gpt >/dev/null 2>&1
    parted -s "$DEV" mkpart primary 1MiB 100% >/dev/null 2>&1
    udevadm settle 2>/dev/null; sleep 1
    P="${DEV}1"; [ -b "$P" ] || P="${DEV}p1"
  fi
  pvcreate -ff -y "$P" >/dev/null 2>&1
  vgcreate vgext "$P" >/dev/null 2>&1
  lvcreate -y -L 256M -n lvext vgext >/dev/null 2>&1
  mkfs.ext4 -F /dev/vgext/lvext >/dev/null 2>&1
fi
mkdir -p /mnt/lvext
grep -q "/mnt/lvext" /etc/fstab 2>/dev/null || \
  echo "/dev/vgext/lvext /mnt/lvext ext4 defaults,nofail 0 0" >>/etc/fstab
mount /mnt/lvext 2>/dev/null || mount -a 2>/dev/null
echo "important data do not lose" >/mnt/lvext/data.txt
echo "lvm-extend: seeded vgext/lvext (256M ext4) at /mnt/lvext"
exit 0
