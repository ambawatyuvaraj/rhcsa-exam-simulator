#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
ckpt_expr "autofs map references the NFS export"    2 'grep -rhs "/exports/rhome" /etc/auto.master /etc/auto.master.d/ /etc/auto.* 2>/dev/null | grep -q .'
ckpt "autofs is enabled"                            2 svc_enabled autofs
ckpt "autofs is active"                             2 svc_active autofs
ckpt_expr "/rhome/remoteuser1 automounts on access" 8 'ls /rhome/remoteuser1/README >/dev/null 2>&1 && findmnt /rhome/remoteuser1 >/dev/null 2>&1'
ckpt_expr "automounted directory is writable"       2 'touch /rhome/remoteuser1/.wtest 2>/dev/null && rm -f /rhome/remoteuser1/.wtest'
