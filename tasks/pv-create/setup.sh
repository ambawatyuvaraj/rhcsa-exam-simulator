#!/usr/bin/env bash
. "$RHCSA_LIB/storage-prep.sh"
DEV="$(ensure_spare_disk)" || { echo "pv-create: could not provide a spare disk"; exit 1; }
echo "pv-create: spare disk = $DEV"
exit 0
