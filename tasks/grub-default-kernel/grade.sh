#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
# Compare the default against the kernel that was running at SEED time (recorded by setup),
# not the current `uname -r`: after the grading reboot the system boots the default, so
# "default == running" would otherwise be trivially true even with no candidate action.
ckpt_expr "default boot kernel is the (seed-time) running kernel" 8 '
  tgt="$(cat /var/lib/rhcsa-sim/grub-target-kernel 2>/dev/null)"; [ -n "$tgt" ] || tgt="$(uname -r)"
  grubby --default-kernel 2>/dev/null | grep -qF "$tgt"'
