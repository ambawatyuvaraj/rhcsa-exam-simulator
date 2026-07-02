#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
: "${RHCSA_STATE:=/var/lib/rhcsa-sim}"
base="$(cat "$RHCSA_STATE/e3-swap.base" 2>/dev/null || echo 0)"
# Credit only NEW swap on a spare-disk partition; the system's own swap must not score.
ckpt_expr "total swap increased by ~512 MiB"        6 "now=\$(free -m | awk '/Swap/{print \$2}'); [ \$(( now - $base )) -ge 480 ]"
ckpt_expr "new swap is active on a partition"        4 'swapon --show=NAME --noheadings 2>/dev/null | grep -qE "^/dev/(vd[b-z]|sd[b-z]|nvme[0-9]+n[0-9]+p)[0-9]+$"'
ckpt_expr "new swap is persistent in /etc/fstab"     4 'nd="$(swapon --show=NAME --noheadings 2>/dev/null | grep -E "/dev/(vd[b-z]|sd[b-z]|nvme)" | head -1)"; nu="$(blkid -s UUID -o value "$nd" 2>/dev/null)"; grep -vE "^[[:space:]]*#" /etc/fstab | grep -w swap | grep -qE "${nd:-ZZNOMATCH}|${nu:-ZZNOMATCH}"'
