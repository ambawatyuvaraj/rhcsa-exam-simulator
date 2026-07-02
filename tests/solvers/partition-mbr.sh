#!/usr/bin/env bash
. "$RHCSA_LIB/storage-prep.sh"; DEV="$(ensure_spare_disk)"
parted -s "$DEV" mklabel msdos 2>/dev/null
parted -s "$DEV" mkpart primary 1MiB $((SZ+10))MiB 2>/dev/null
udevadm settle 2>/dev/null; sleep 1
