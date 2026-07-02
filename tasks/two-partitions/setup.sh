#!/usr/bin/env bash
. "$RHCSA_LIB/storage-prep.sh"
DEV="$(ensure_spare_disk)" || { echo "two-partitions: could not provide a spare disk"; exit 1; }
echo "two-partitions: spare disk = $DEV"
exit 0
