#!/usr/bin/env bash
mkdir -p /mnt/peernfs
grep -q "/mnt/peernfs" /etc/fstab || \
  echo "$PEER_ROLE.example.com:/exports/nodeshare /mnt/peernfs nfs defaults 0 0" >>/etc/fstab
mount -a >/dev/null 2>&1
