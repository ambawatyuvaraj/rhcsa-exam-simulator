#!/usr/bin/env bash
. "$RHCSA_LIB/storage-prep.sh"; DEV="$(ensure_spare_disk)"
parted -s "$DEV" mklabel gpt 2>/dev/null
parted -s "$DEV" mkpart primary 1MiB 1024MiB 2>/dev/null; udevadm settle 2>/dev/null; sleep 1
P="${DEV}1"; [ -b "$P" ] || P="${DEV}p1"
pvcreate -ff -y "$P" >/dev/null 2>&1; vgcreate -s 16M myvg "$P" >/dev/null 2>&1
lvcreate -y -l 50 -n mylv myvg >/dev/null 2>&1; mkfs.vfat /dev/myvg/mylv >/dev/null 2>&1
mkdir -p /mnt/mydata; grep -q /mnt/mydata /etc/fstab || echo "/dev/myvg/mylv /mnt/mydata vfat defaults,nofail 0 0" >>/etc/fstab; mount -a 2>/dev/null
