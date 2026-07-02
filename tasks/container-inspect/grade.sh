#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
ckpt_expr "file contains the image's ID" 8 'want=$(podman image inspect --format "{{.Id}}" localhost/rhcsa-app:latest 2>/dev/null); [ -n "$want" ] && grep -q "$want" /root/'"$OUTF"''
