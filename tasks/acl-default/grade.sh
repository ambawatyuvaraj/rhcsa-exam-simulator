#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
ckpt "/$DIR is a directory" 2 is_dir "/$DIR"
ckpt_expr "default ACL grants group $G rwx" 6 \
  'getfacl -p /'"$DIR"' 2>/dev/null | grep -q "default:group:'"$G"':rwx"'
