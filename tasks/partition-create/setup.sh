#!/usr/bin/env bash
. "$RHCSA_LIB/storage-prep.sh"
DEV="$(ensure_spare_disk)" || { echo "partition-create: could not provide a spare disk"; exit 1; }
# Clean any prior attempt at this mountpoint (candidate creates everything).
umount "/mnt/$MP" 2>/dev/null
sed -i '\#/mnt/'"$MP"'#d' /etc/fstab 2>/dev/null
rm -rf "/mnt/$MP" 2>/dev/null
echo "partition-create: spare disk = $DEV"
exit 0
