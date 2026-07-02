#!/usr/bin/env bash
. "$RHCSA_LIB/storage-prep.sh"; DEV="$(ensure_spare_disk)"
parted -s "$DEV" mklabel gpt 2>/dev/null
parted -s "$DEV" mkpart primary linux-swap 1MiB 600MiB 2>/dev/null
udevadm settle 2>/dev/null; sleep 1
P="${DEV}1"; [ -b "$P" ] || P="${DEV}p1"
mkswap "$P" >/dev/null 2>&1
grep -q "$P" /etc/fstab || echo "$P swap swap defaults,nofail 0 0" >> /etc/fstab
swapon "$P" 2>/dev/null
