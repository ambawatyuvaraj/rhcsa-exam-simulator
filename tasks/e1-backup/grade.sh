#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
ckpt "/root/test.tar.gz exists"                 3 path_exists /root/test.tar.gz
ckpt_expr "archive is gzip-compressed"          3 'file /root/test.tar.gz | grep -qi "gzip compressed" || gzip -t /root/test.tar.gz 2>/dev/null'
ckpt_expr "archive contains /var/tmp content"   4 'tar tzf /root/test.tar.gz 2>/dev/null | grep -qE "(^|/)var/tmp/"'
