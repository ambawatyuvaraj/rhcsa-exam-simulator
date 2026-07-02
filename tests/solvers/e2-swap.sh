#!/usr/bin/env bash
. "$RHCSA_LIB/storage-prep.sh"
DEV="$(ensure_shared_disk e2storage)" || exit 1
# ADD a 512 MiB swap partition WITHOUT wiping any LVM partition already on the disk.
sfdisk -d "$DEV" >/dev/null 2>&1 || echo 'label: dos' | sfdisk -q "$DEV" >/dev/null 2>&1
pre="$(lsblk -rno NAME "$DEV" 2>/dev/null | tail -n +2 | sort)"
echo ',512M,82' | sfdisk --no-reread --force -q -a "$DEV" >/dev/null 2>&1
# partx -a registers the NEW partition even when the disk is busy (another
# partition already mounted/swap-active) — a full re-read (partprobe) fails then.
partx -a "$DEV" >/dev/null 2>&1; partprobe "$DEV" >/dev/null 2>&1; udevadm settle 2>/dev/null; sleep 1
P="/dev/$(comm -13 <(echo "$pre") <(lsblk -rno NAME "$DEV" 2>/dev/null | tail -n +2 | sort) | head -1)"
[ -b "$P" ] || exit 1
mkswap "$P" >/dev/null 2>&1
uu="$(blkid -s UUID -o value "$P" 2>/dev/null)"
grep -q "${uu:-NOUUIDXX}" /etc/fstab 2>/dev/null || echo "UUID=$uu swap swap defaults,nofail 0 0" >> /etc/fstab
swapon "$P" 2>/dev/null
