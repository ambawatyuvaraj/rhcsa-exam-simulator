#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
ckpt "mode of $TGT is $MODE"   4 file_mode  "$TGT" "$MODE"
ckpt "owner of $TGT is root"   3 file_owner "$TGT" root
ckpt "group of $TGT is root"   3 file_group "$TGT" root
