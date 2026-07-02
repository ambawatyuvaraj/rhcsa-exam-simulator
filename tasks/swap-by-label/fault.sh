#!/usr/bin/env bash
# Troubleshooting fault: deactivate the swap and remove its fstab entry (the
# swap area on the partition stays, but it is no longer active or persistent).
swapoff -L "$LBL" >/dev/null 2>&1 || true
sed -i "\\#LABEL=$LBL#d" /etc/fstab 2>/dev/null
echo "SYMPTOM: the labelled swap is not active and has no /etc/fstab entry (it will not return after a reboot)"
