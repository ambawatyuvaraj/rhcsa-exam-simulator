#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
ckpt_expr "volume group myvg exists"         3 'vgs myvg >/dev/null 2>&1'
ckpt "PE (extent) size is 16 MiB"            3 vg_extent_size myvg 16
ckpt "logical volume myvg/mylv exists"       4 lv_exists myvg mylv
ckpt "mylv size is ~50 extents (~800 MiB)"   2 lv_size_between /dev/myvg/mylv 760 840
ckpt "filesystem at /mnt/mydata is vfat"     3 fs_type /mnt/mydata vfat
ckpt "mounted & persistent at /mnt/mydata"   3 mount_persistent /mnt/mydata
