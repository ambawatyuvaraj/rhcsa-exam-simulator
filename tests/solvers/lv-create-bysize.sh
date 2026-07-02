#!/usr/bin/env bash
. "$RHCSA_LIB/storage-prep.sh"; ensure_spare_disk >/dev/null
lvcreate -y -L "${SZ}M" -n "$LV" "$VG" >/dev/null 2>&1
mkfs.xfs -f "/dev/$VG/$LV" >/dev/null 2>&1
mkdir -p "/mnt/$MP"
grep -q "/mnt/$MP" /etc/fstab || echo "/dev/$VG/$LV /mnt/$MP xfs defaults,nofail 0 0" >>/etc/fstab
mount -a 2>/dev/null
