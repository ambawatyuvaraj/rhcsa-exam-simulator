#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
: "${RHCSA_STATE:=/var/lib/rhcsa-sim}"
base="$(cat "$RHCSA_STATE/swap.base" 2>/dev/null || echo 0)"
ckpt_expr "total swap increased by ~512 MiB" 6 "now=\$(free -m | awk '/Swap/{print \$2}'); [ \$(( now - $base )) -ge 480 ]"
ckpt_expr "a swap entry exists in /etc/fstab"  5 'grep -vE "^[[:space:]]*#" /etc/fstab | grep -qw swap'
ckpt_expr "new swap is currently active"       3 'swapon --show=NAME --noheadings 2>/dev/null | grep -q .'
