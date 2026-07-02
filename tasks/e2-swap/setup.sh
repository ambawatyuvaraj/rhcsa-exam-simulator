#!/usr/bin/env bash
# Swap lives on the SHARED storage disk (the LVM task uses another partition on
# the same disk — faithful to the answer key's /dev/vdb part3=swap, part2=LVM).
. "$RHCSA_LIB/storage-prep.sh"
dev="$(ensure_shared_disk e2storage)" || { echo "e2-swap: could not provide a spare disk"; exit 1; }
# record baseline swap (MiB) so grading credits only the NEW swap
free -m | awk '/Swap/{print $2}' >"$RHCSA_STATE/e2-swap.base"
echo "e2-swap: shared storage disk = $dev (add a ~512 MiB swap partition on it)"
exit 0
