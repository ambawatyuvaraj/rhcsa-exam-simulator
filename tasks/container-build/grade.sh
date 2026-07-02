#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
ckpt_expr "image $IMG was built" 10 'podman image exists '"$IMG"''
