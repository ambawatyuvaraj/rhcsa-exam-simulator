#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
ckpt "/root/test.tar.gz exists"                 2 path_exists /root/test.tar.gz
ckpt_expr "test.tar.gz is gzip-compressed"      2 'file /root/test.tar.gz | grep -qi "gzip compressed" || gzip -t /root/test.tar.gz 2>/dev/null'
ckpt_expr "test.tar.gz contains /var/tmp"        1 'tar tzf /root/test.tar.gz 2>/dev/null | grep -qE "(^|/)var/tmp/"'
ckpt "/root/test.tar.bz exists"                 2 path_exists /root/test.tar.bz
ckpt_expr "test.tar.bz is bzip2-compressed"     2 'file /root/test.tar.bz | grep -qi "bzip2 compressed" || bzip2 -t /root/test.tar.bz 2>/dev/null'
ckpt_expr "test.tar.bz contains /var/tmp"        1 'tar tjf /root/test.tar.bz 2>/dev/null | grep -qE "(^|/)var/tmp/"'
