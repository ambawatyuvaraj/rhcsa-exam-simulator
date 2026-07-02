#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
ckpt "logical volume $VG/$LV exists"            4 lv_exists "$VG" "$LV"
ckpt "$LV size is ~${SZ} MiB"                   4 lv_size_between "/dev/$VG/$LV" "$((SZ-20))" "$((SZ+20))"
ckpt "filesystem at /mnt/$MP is xfs"            4 fs_type "/mnt/$MP" xfs
ckpt "mounted & persistent at /mnt/$MP"         4 mount_persistent "/mnt/$MP"
