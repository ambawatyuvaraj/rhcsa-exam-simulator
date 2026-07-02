#!/usr/bin/env bash
. "$RHCSA_LIB/storage-prep.sh"
DEV="$(ensure_shared_disk e1storage)" || exit 1
# ADD a 2 GiB LVM partition WITHOUT wiping any swap partition already on the disk.
sfdisk -d "$DEV" >/dev/null 2>&1 || echo 'label: dos' | sfdisk -q "$DEV" >/dev/null 2>&1
pre="$(lsblk -rno NAME "$DEV" 2>/dev/null | tail -n +2 | sort)"
echo ',2G,8e' | sfdisk --no-reread --force -q -a "$DEV" >/dev/null 2>&1
# partx -a registers the NEW partition even when vdb1 swap is already active
# (a full re-read via partprobe fails on a busy disk, so vdb2 wouldn't appear).
partx -a "$DEV" >/dev/null 2>&1; partprobe "$DEV" >/dev/null 2>&1; udevadm settle 2>/dev/null; sleep 1
P="/dev/$(comm -13 <(echo "$pre") <(lsblk -rno NAME "$DEV" 2>/dev/null | tail -n +2 | sort) | head -1)"
[ -b "$P" ] || exit 1
pvcreate -ff -y "$P" >/dev/null 2>&1
vgcreate -s 8M datastore "$P" >/dev/null 2>&1
lvcreate -y -l 50 -n database datastore >/dev/null 2>&1
mkfs.ext3 -F /dev/datastore/database >/dev/null 2>&1
mkdir -p /mnt/database
uu="$(blkid -s UUID -o value /dev/datastore/database 2>/dev/null)"
grep -q "/mnt/database" /etc/fstab 2>/dev/null || echo "UUID=$uu /mnt/database ext3 defaults,nofail 0 0" >> /etc/fstab
mount -a 2>/dev/null
