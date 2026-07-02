#!/usr/bin/env bash
mkdir -p "/mnt/$MP"
grep -q "/mnt/$MP" /etc/fstab || \
  echo "localhost:/exports/ro /mnt/$MP nfs ro,_netdev 0 0" >>/etc/fstab
mount -a 2>/dev/null
