#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"

ckpt "/home/contrib is a directory"            2 is_dir /home/contrib
ckpt "group owner is manager"                    3 file_group /home/contrib manager
ckpt_expr "permissions are 2770 (rwxrws---)"     4 '[ "$(stat -c %a /home/contrib)" = "2770" ]'
ckpt "set-GID bit is set on the directory"       3 has_setgid /home/contrib
