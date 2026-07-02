#!/usr/bin/env bash
. "$RHCSA_LIB/storage-prep.sh"
DEV="$(ensure_spare_disk)" || { echo "gpt-name: could not provide a spare disk"; exit 1; }
echo "gpt-name: spare disk = $DEV"
exit 0
