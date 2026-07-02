#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
ckpt_expr "console VC keymap is $KM" 8 'localectl status 2>/dev/null | grep -i "VC Keymap" | grep -qw "$KM"'
