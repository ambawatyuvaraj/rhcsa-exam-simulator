#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
# 50 extents x 16 MiB PE = 800 MiB. This LV is NOT resized by any other task, so
# the size is checked tightly.
ckpt_expr "volume group myvg exists"          3 'vgs myvg >/dev/null 2>&1'
ckpt "PE (extent) size is 16 MiB"             2 vg_extent_size myvg 16
ckpt "logical volume myvg/mylv exists"        4 lv_exists myvg mylv
ckpt "mylv is ~50 extents (~800 MiB)"         2 lv_size_between /dev/myvg/mylv 760 840
ckpt "filesystem at /mnt/mydata is vfat"      2 fs_type /mnt/mydata vfat
ckpt "mounted & persistent at /mnt/mydata"    2 mount_persistent /mnt/mydata
