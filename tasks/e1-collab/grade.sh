#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"

ckpt "/common/admin is a directory"                              2 is_dir /common/admin
ckpt "group owner is admin"                                      3 file_group /common/admin admin
ckpt_expr "permissions are 2770 (set-GID, rwxrwx---)"            5 '[ "$(stat -c %a /common/admin)" = "2770" ]'
