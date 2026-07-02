#!/usr/bin/env bash
. "$RHCSA_LIB/storage-prep.sh"; DEV="$(ensure_spare_disk)"
P="${DEV}1"; [ -b "$P" ] || P="${DEV}p1"
umount "$P" 2>/dev/null            # parted won't resize a mounted partition
parted -s "$DEV" resizepart 1 400MiB 2>/dev/null
udevadm settle 2>/dev/null; sleep 1
e2fsck -fy "$P" >/dev/null 2>&1
resize2fs "$P" >/dev/null 2>&1
mkdir -p "/mnt/$MP"; mount "$P" "/mnt/$MP" 2>/dev/null
