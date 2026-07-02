#!/usr/bin/env bash
. "$RHCSA_LIB/storage-prep.sh"; ensure_spare_disk >/dev/null
lvrename "$VG" "$OLD" "$NEW" >/dev/null 2>&1
