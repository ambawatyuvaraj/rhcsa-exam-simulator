#!/usr/bin/env bash
. "$RHCSA_LIB/storage-prep.sh"; ensure_spare_disk >/dev/null
lvreduce -r -y -L 300M "/dev/$VG/$LV" >/dev/null 2>&1
