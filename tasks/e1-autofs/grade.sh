#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
ckpt_expr "autofs map references the NFS export"    2 'grep -rhs "/exports/localhome" /etc/auto.master /etc/auto.master.d/ /etc/auto.* 2>/dev/null | grep -q .'
ckpt "autofs is enabled"                            2 svc_enabled autofs
ckpt "autofs is active"                             2 svc_active autofs
ckpt_expr "/localhome/production5 automounts on access" 8 'ls /localhome/production5/README >/dev/null 2>&1 && findmnt /localhome/production5 >/dev/null 2>&1'
ckpt_expr "automounted directory is writable"       2 'touch /localhome/production5/.wtest 2>/dev/null && rm -f /localhome/production5/.wtest'
