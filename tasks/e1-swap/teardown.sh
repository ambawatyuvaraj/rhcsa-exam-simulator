#!/usr/bin/env bash
. "$RHCSA_LIB/storage-prep.sh"
# swapoff + remove ONLY the spare-disk swap's fstab entry (never the system swap),
# then wipe the shared disk back to bare.
nd="$(swapon --show=NAME --noheadings 2>/dev/null | grep -E '/dev/(vd[b-z]|sd[b-z]|nvme)' | head -1)"
if [ -n "$nd" ]; then
  nu="$(blkid -s UUID -o value "$nd" 2>/dev/null)"
  swapoff "$nd" 2>/dev/null
  [ -n "$nu" ] && sed -i "\\#UUID=$nu#d" /etc/fstab 2>/dev/null
  sed -i "\\#^$nd[[:space:]]#d" /etc/fstab 2>/dev/null
fi
shared_cleanup e1storage
rm -f "$RHCSA_STATE/e1-swap.base" 2>/dev/null
exit 0
