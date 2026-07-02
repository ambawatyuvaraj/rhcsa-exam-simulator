#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
ckpt "/root/$ARC.tar.bz2 exists" 3 path_exists "/root/$ARC.tar.bz2"
ckpt_expr "archive is bzip2-compressed" 4 'file "/root/'"$ARC"'.tar.bz2" | grep -qi "bzip2 compressed"'
ckpt_expr "archive contains /opt/bz content" 3 'tar tjf "/root/'"$ARC"'.tar.bz2" 2>/dev/null | grep -qE "(^|/)bz/"'
