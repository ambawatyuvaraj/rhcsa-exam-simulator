#!/usr/bin/env bash
mkdir -p "/mnt/$MP"
grep -q "/mnt/$MP" /etc/fstab || \
  echo "/root/$ISO.iso /mnt/$MP iso9660 loop,ro 0 0" >>/etc/fstab
mount -a 2>/dev/null
