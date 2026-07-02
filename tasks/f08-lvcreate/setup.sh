#!/usr/bin/env bash
. "$RHCSA_LIB/storage-prep.sh"
dev="$(ensure_spare_disk)" || { echo "lvm-create: could not provide a spare disk"; exit 1; }
vgremove -f wgroup >/dev/null 2>&1 || true
rm -rf /mnt/wshare 2>/dev/null
echo "lvm-create: spare disk = $dev"
exit 0
