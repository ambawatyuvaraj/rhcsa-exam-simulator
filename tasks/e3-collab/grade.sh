#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"

ckpt "/common/shared is a directory"                              2 is_dir /common/shared
ckpt "group owner is admin"                                      3 file_group /common/shared admin
ckpt_expr "permissions are 2770 (set-GID, rwxrwx---)"            5 '[ "$(stat -c %a /common/shared)" = "2770" ]'
