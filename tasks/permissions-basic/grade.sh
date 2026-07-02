#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
ckpt "mode is $MODE" 5 file_mode "$TGT" "$MODE"
ckpt "owner is root" 2 file_owner "$TGT" root
ckpt "group is root" 1 file_group "$TGT" root
