#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
ckpt_expr "image localhost/rhcsa-app:latest present" 6 'podman image exists localhost/rhcsa-app:latest'
