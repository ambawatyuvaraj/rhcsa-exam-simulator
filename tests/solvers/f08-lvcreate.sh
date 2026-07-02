#!/usr/bin/env bash
. "$RHCSA_LIB/storage-prep.sh"; DEV="$(ensure_spare_disk)"
parted -s "$DEV" mklabel gpt 2>/dev/null
parted -s "$DEV" mkpart primary 1MiB 900MiB 2>/dev/null; udevadm settle 2>/dev/null; sleep 1
P="${DEV}1"; [ -b "$P" ] || P="${DEV}p1"
pvcreate -ff -y "$P" >/dev/null 2>&1
vgcreate -s 8M wgroup "$P" >/dev/null 2>&1
lvcreate -y -l 100 -n wshare wgroup >/dev/null 2>&1
mkfs.vfat /dev/wgroup/wshare >/dev/null 2>&1
mkdir -p /mnt/wshare
grep -q /mnt/wshare /etc/fstab || echo "/dev/wgroup/wshare /mnt/wshare vfat defaults,nofail 0 0" >> /etc/fstab
mount -a 2>/dev/null
