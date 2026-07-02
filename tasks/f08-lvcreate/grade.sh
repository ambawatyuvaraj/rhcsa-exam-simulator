#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
ckpt_expr "volume group wgroup exists"         3 'vgs wgroup >/dev/null 2>&1'
ckpt "PE (extent) size is 8 MiB"            3 vg_extent_size wgroup 8
ckpt "logical volume wgroup/wshare exists"       4 lv_exists wgroup wshare
ckpt "wshare size is ~100 extents (~800 MiB)"   2 lv_size_between /dev/wgroup/wshare 760 840
ckpt "filesystem at /mnt/wshare is vfat"     3 fs_type /mnt/wshare vfat
ckpt "mounted & persistent at /mnt/wshare"   3 mount_persistent /mnt/wshare
