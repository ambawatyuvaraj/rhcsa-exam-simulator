#!/usr/bin/env bash
mkdir -p "/mnt/$MP"
grep -q "/mnt/$MP" /etc/fstab || \
  echo "LABEL=$LBL /mnt/$MP ext4 defaults,nofail 0 0" >>/etc/fstab
mount -a 2>/dev/null
