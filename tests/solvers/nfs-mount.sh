#!/usr/bin/env bash
# Persistently mount the localhost:/exports/share2 NFS export.
mkdir -p "/mnt/$MP"
grep -vE '^\s*#' /etc/fstab | grep -q "/mnt/$MP" || \
  echo "localhost:/exports/share2 /mnt/$MP nfs defaults,_netdev 0 0" >>/etc/fstab
systemctl daemon-reload 2>/dev/null
mount "/mnt/$MP" 2>/dev/null || mount -a 2>/dev/null
