#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
ckpt_expr "/swapfile is an active swap device" 5 \
  'swapon --show=NAME --noheadings 2>/dev/null | grep -qx /swapfile'
ckpt_expr "fstab enables /swapfile at boot" 5 \
  'grep -vE "^\s*#" /etc/fstab | grep "^/swapfile" | grep -qw swap'
