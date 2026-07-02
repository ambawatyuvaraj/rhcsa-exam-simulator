#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
ckpt "/$DIR is a directory" 2 is_dir "/$DIR"
ckpt "group owner of /$DIR is $G" 3 file_group "/$DIR" "$G"
ckpt "set-GID bit is set on /$DIR" 3 has_setgid "/$DIR"
