#!/usr/bin/env bash
. "$RHCSA_LIB/storage-prep.sh"; DEV="$(ensure_spare_disk)"
parted -s "$DEV" mkpart primary 300MiB 600MiB 2>/dev/null
udevadm settle 2>/dev/null; sleep 1
P2="${DEV}2"; [ -b "$P2" ] || P2="${DEV}p2"
pvcreate -ff -y "$P2" >/dev/null 2>&1
vgextend "$VG" "$P2" >/dev/null 2>&1
