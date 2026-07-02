#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
ckpt "/root/archive.gz exists"                  3 path_exists /root/archive.gz
ckpt_expr "archive is gzip-compressed"          3 'file /root/archive.gz | grep -qi "gzip compressed" || gzip -t /root/archive.gz 2>/dev/null'
ckpt_expr "archive contains /usr/local content" 4 'tar tzf /root/archive.gz 2>/dev/null | grep -qE "(^|/)usr/local/"'
