#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
SVC="${SVC:-chronyd}"
ckpt "$SVC enabled and active" 8 svc_ok "$SVC"
