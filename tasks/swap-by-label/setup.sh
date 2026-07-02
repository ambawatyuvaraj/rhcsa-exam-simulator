#!/usr/bin/env bash
. "$RHCSA_LIB/storage-prep.sh"
DEV="$(ensure_spare_disk)" || { echo "swap-by-label: could not provide a spare disk"; exit 1; }
sed -i '\#LABEL='"$LBL"'#d' /etc/fstab 2>/dev/null
echo "swap-by-label: spare disk = $DEV"
exit 0
