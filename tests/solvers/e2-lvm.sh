#!/usr/bin/env bash
. "$RHCSA_LIB/storage-prep.sh"
DEV="$(ensure_shared_disk e2storage)" || exit 1
# ADD a ~1 GiB LVM partition WITHOUT wiping any swap partition already on the disk.
sfdisk -d "$DEV" >/dev/null 2>&1 || echo 'label: dos' | sfdisk -q "$DEV" >/dev/null 2>&1
pre="$(lsblk -rno NAME "$DEV" 2>/dev/null | tail -n +2 | sort)"
echo ',1G,8e' | sfdisk --no-reread --force -q -a "$DEV" >/dev/null 2>&1
partx -a "$DEV" >/dev/null 2>&1; partprobe "$DEV" >/dev/null 2>&1; udevadm settle 2>/dev/null; sleep 1
P="/dev/$(comm -13 <(echo "$pre") <(lsblk -rno NAME "$DEV" 2>/dev/null | tail -n +2 | sort) | head -1)"
[ -b "$P" ] || exit 1
pvcreate -ff -y "$P" >/dev/null 2>&1
vgcreate -s 16M myvg "$P" >/dev/null 2>&1
lvcreate -y -l 50 -n mylv myvg >/dev/null 2>&1
mkfs.vfat /dev/myvg/mylv >/dev/null 2>&1
mkdir -p /mnt/mydata
uu="$(blkid -s UUID -o value /dev/myvg/mylv 2>/dev/null)"
grep -q "/mnt/mydata" /etc/fstab 2>/dev/null || echo "UUID=$uu /mnt/mydata vfat defaults,nofail 0 0" >> /etc/fstab
mount -a 2>/dev/null
