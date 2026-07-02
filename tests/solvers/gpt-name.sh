#!/usr/bin/env bash
. "$RHCSA_LIB/storage-prep.sh"; DEV="$(ensure_spare_disk)"
parted -s "$DEV" mklabel gpt 2>/dev/null
parted -s "$DEV" mkpart "$PNAME" 1MiB 300MiB 2>/dev/null
udevadm settle 2>/dev/null; sleep 1
