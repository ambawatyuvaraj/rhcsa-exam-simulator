#!/usr/bin/env bash
. "$RHCSA_LIB/storage-prep.sh"; DEV="$(ensure_spare_disk)"
parted -s "$DEV" mklabel gpt 2>/dev/null
parted -s "$DEV" mkpart primary 1MiB 400MiB 2>/dev/null
udevadm settle 2>/dev/null; sleep 1
P="${DEV}1"; [ -b "$P" ] || P="${DEV}p1"
pvcreate -ff -y "$P" >/dev/null 2>&1
vgcreate -s "${PE}M" "$VG" "$P" >/dev/null 2>&1
