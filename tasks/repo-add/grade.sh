#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
ckpt_expr "repo $RID enabled in dnf" 5 'dnf -q repolist enabled 2>/dev/null | awk "{print \$1}" | grep -qx '"$RID"''
ckpt_expr "baseurl points to file://$DIR" 3 'grep -rhA8 "^\['"$RID"'\]" /etc/yum.repos.d/*.repo 2>/dev/null | grep -q "file://'"$DIR"'"'
