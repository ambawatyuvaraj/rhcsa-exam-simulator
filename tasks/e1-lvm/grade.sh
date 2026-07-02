#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
# Size is checked only as ">= ~50 extents (~400 MiB)" because the resize task
# (e1-lvresize) grows this same LV to 100 extents; an exact-50 check would then
# fail after the candidate completes both tasks.
ckpt_expr "volume group datastore exists"            3 'vgs datastore >/dev/null 2>&1'
ckpt "PE (extent) size is 8 MiB"                     2 vg_extent_size datastore 8
ckpt "logical volume datastore/database exists"      4 lv_exists datastore database
ckpt "database is at least ~50 extents (~400 MiB)"   2 lv_size_between /dev/datastore/database 380 100000
ckpt "filesystem at /mnt/database is ext3"           2 fs_type /mnt/database ext3
ckpt "mounted & persistent at /mnt/database"         2 mount_persistent /mnt/database
