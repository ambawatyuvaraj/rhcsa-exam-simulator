#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
ckpt "/var/tmp/fstab exists"                   2 path_exists /var/tmp/fstab
ckpt "owner is root"                           1 file_owner /var/tmp/fstab root
ckpt "group is root"                           1 file_group /var/tmp/fstab root
  ckpt_expr "not executable by anyone"           2 '[ -e /var/tmp/fstab ] && ! stat -c %A /var/tmp/fstab 2>/dev/null | grep -q x'
ckpt "harry has rw- via ACL"                   4 acl_has /var/tmp/fstab user:harry:rw-
ckpt "natasha has --- via ACL"                   3 acl_has /var/tmp/fstab user:natasha:---
ckpt_expr "other users can read"               1 'getfacl -p /var/tmp/fstab 2>/dev/null | grep -qE "^other::r"'
