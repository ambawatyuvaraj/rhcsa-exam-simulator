#!/usr/bin/env bash
. "$RHCSA_LIB/storage-prep.sh"
# swapoff + drop only the spare-disk swap's fstab line, then wipe the shared disk
nd="$(swapon --show=NAME --noheadings 2>/dev/null | grep -E '/dev/(vd[b-z]|sd[b-z]|nvme)' | head -1)"
if [ -n "$nd" ]; then
  nu="$(blkid -s UUID -o value "$nd" 2>/dev/null)"
  swapoff "$nd" 2>/dev/null
  [ -n "$nu" ] && sed -i "\#UUID=$nu#d" /etc/fstab 2>/dev/null
  sed -i "\#^$nd[[:space:]]#d" /etc/fstab 2>/dev/null
fi
shared_cleanup f08storage
rm -f "$RHCSA_STATE/swap.base" 2>/dev/null
exit 0
