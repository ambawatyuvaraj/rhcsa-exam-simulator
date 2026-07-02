#!/usr/bin/env bash
. "$RHCSA_LIB/storage-prep.sh"
DEV="$(ensure_spare_disk)" || { echo "swap-priority: could not provide a spare disk"; exit 1; }
echo "swap-priority: spare disk = $DEV"
exit 0
