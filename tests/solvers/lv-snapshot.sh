#!/usr/bin/env bash
. "$RHCSA_LIB/storage-prep.sh"; ensure_spare_disk >/dev/null
lvcreate -y -s -L 100M -n "$SNAP" "/dev/$VG/$LV" >/dev/null 2>&1
