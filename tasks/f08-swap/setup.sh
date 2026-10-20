#!/usr/bin/env bash
. "$RHCSA_LIB/storage-prep.sh"
# Shares ONE disk with f08-lvresize (whose VG sits on partition 1).
dev="$(ensure_shared_disk f08storage)" || { echo "swap-partition: could not provide a spare disk"; exit 1; }
# record baseline swap (MiB) so grading can detect the increase
free -m | awk '/Swap/{print $2}' >"$RHCSA_STATE/swap.base"
echo "swap-partition: spare disk = $dev (baseline swap recorded)"
exit 0
