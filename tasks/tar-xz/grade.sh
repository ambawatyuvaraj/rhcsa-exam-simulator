#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
ckpt "/root/$ARC.tar.xz exists" 3 path_exists "/root/$ARC.tar.xz"
ckpt_expr "archive is XZ-compressed" 4 'file "/root/'"$ARC"'.tar.xz" | grep -qi "XZ compressed"'
ckpt_expr "archive contains /opt/xz content" 3 'tar tJf "/root/'"$ARC"'.tar.xz" 2>/dev/null | grep -qE "(^|/)xz/"'
