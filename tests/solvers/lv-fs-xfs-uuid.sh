#!/usr/bin/env bash
. "$RHCSA_LIB/storage-prep.sh"; ensure_spare_disk >/dev/null
mkfs.xfs -f "/dev/$VG/$LV" >/dev/null 2>&1
mkdir -p "/mnt/$MP"
U="$(blkid -s UUID -o value "/dev/$VG/$LV")"
grep -q "/mnt/$MP" /etc/fstab || echo "UUID=$U /mnt/$MP xfs defaults,nofail 0 0" >>/etc/fstab
mount -a 2>/dev/null
