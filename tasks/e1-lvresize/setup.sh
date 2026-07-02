#!/usr/bin/env bash
# The datastore VG + database LV are created by the LVM task (e1-lvm) on the
# SAME shared disk; this task only extends them. No seeding here, so the LVM
# task's baseline stays clean (nothing to resize until it has been created).
. "$RHCSA_LIB/storage-prep.sh"
ensure_shared_disk e1storage >/dev/null 2>&1
echo "e1-lvresize: extend datastore/database to 100 extents (created in the LVM task)"
exit 0
