#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
ckpt "$SVC enabled and active" 8 svc_ok "$SVC"
