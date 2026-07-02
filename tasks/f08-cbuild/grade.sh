#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
ckpt_expr "image 'monitor' was built by walhalla" 10 'su - walhalla -c "podman image exists localhost/monitor:latest || podman image exists monitor" >/dev/null 2>&1'
