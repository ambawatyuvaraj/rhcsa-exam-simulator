#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
ckpt "default target is multi-user.target"     8 default_target multi-user.target
