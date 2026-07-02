#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"

ckpt "/home/managers is a directory"                             2 is_dir /home/managers
ckpt "group owner is sysmgrs"                                    3 file_group /home/managers sysmgrs
ckpt_expr "permissions are 2770 (set-GID, rwxrwx---)"            5 '[ "$(stat -c %a /home/managers)" = "2770" ]'
