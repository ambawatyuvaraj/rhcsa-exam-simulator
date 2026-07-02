#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
ckpt "/root/backup.tar.gz exists"                  3 path_exists /root/backup.tar.gz
ckpt_expr "archive is gzip-compressed"             4 'file /root/backup.tar.gz | grep -qiE "gzip compressed"'
ckpt_expr "archive contains /etc content"          3 'tar tzf /root/backup.tar.gz 2>/dev/null | grep -qE "(^|/)etc/"'
