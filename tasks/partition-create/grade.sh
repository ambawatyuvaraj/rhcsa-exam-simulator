#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
ckpt "filesystem at /mnt/$MP is ext4"      4 fs_type "/mnt/$MP" ext4
ckpt "mounted & persistent at /mnt/$MP"    6 mount_persistent "/mnt/$MP"
