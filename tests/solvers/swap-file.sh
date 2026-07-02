#!/usr/bin/env bash
dd if=/dev/zero of=/swapfile bs=1M count="$SZ" status=none 2>/dev/null
chmod 600 /swapfile
mkswap /swapfile >/dev/null 2>&1
grep -q "^/swapfile" /etc/fstab || echo "/swapfile none swap defaults,nofail 0 0" >>/etc/fstab
swapon -a 2>/dev/null
