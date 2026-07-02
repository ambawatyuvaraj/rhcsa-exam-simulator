#!/usr/bin/env bash
. "$RHCSA_LIB/storage-prep.sh"
DEV="$(ensure_spare_disk)" || { echo "vg-pe-size: could not provide a spare disk"; exit 1; }
vgremove -f "$VG" >/dev/null 2>&1 || true
echo "vg-pe-size: spare disk = $DEV"
exit 0
