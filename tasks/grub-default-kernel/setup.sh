#!/usr/bin/env bash
mkdir -p /var/lib/rhcsa-sim
grubby --default-kernel > /var/lib/rhcsa-sim/grub-default-kernel.bak 2>/dev/null || true
# Record the kernel running at SEED time — the one the candidate must make default. The
# grader compares against THIS, not the live `uname -r`, because after the grading reboot
# the system boots whatever is default, which would make "default == running" trivially true.
uname -r > /var/lib/rhcsa-sim/grub-target-kernel 2>/dev/null
# Point the default at a DIFFERENT installed kernel so the candidate must change it back
# (otherwise the already-default running kernel would pass the grade with zero work).
running="/boot/vmlinuz-$(uname -r)"
other="$(ls -1 /boot/vmlinuz-* 2>/dev/null | grep -v rescue | grep -vxF "$running" | sort -V | tail -1)"
[ -n "$other" ] && grubby --set-default "$other" >/dev/null 2>&1
echo "grub-default-kernel: default pointed at an alternate kernel (candidate must reset to the running one)"
exit 0
