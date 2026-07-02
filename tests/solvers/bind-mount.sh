#!/usr/bin/env bash
mkdir -p "/mnt/$MP"
grep -q "/mnt/$MP" /etc/fstab || \
  echo "/srv/$SRC /mnt/$MP none bind 0 0" >>/etc/fstab
mount -a 2>/dev/null
