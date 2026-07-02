#!/usr/bin/env bash
mkdir -p "/mnt/$MP"
grep -q "/mnt/$MP" /etc/fstab || \
  echo "tmpfs /mnt/$MP tmpfs size=${SZ}M 0 0" >>/etc/fstab
mount -a 2>/dev/null
