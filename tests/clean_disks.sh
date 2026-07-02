#!/usr/bin/env bash
# Test-only: free all spare disks (vd[b-z]) and undo sim mounts/swaps/VGs so the
# next batch starts clean. NEVER touches the root disk or root VG. Run as root.
set -uo pipefail
ROOTSRC="$(findmnt -no SOURCE / 2>/dev/null)"
ROOTDISK="$(lsblk -no PKNAME "$ROOTSRC" 2>/dev/null | head -1)"

# Unmount sim mountpoints and automounts
for m in $(findmnt -rn -o TARGET 2>/dev/null | grep -E '^/(mnt|autohomes|shared-tmp|team|restricted|webdata)'); do
  umount -lf "$m" 2>/dev/null
done
umount -lf /autohomes/* 2>/dev/null
systemctl stop autofs 2>/dev/null

# Disable swap on spare disks / swapfile (leave root swap; re-enable at end)
swapoff -a 2>/dev/null

# Remove any VG that has a PV on a spare disk (never the root VG)
for vg in $(vgs --noheadings -o vg_name 2>/dev/null | tr -d ' '); do
  if pvs --noheadings -o pv_name,vg_name 2>/dev/null | awk -v v="$vg" '$2==v{print $1}' | grep -q '/dev/vd[b-z]'; then
    vgchange -an "$vg" 2>/dev/null; vgremove -f "$vg" 2>/dev/null
  fi
done

# Wipe every spare disk and its partitions
for d in /dev/vd[b-z]; do
  [ -b "$d" ] || continue
  [ "$(basename "$d")" = "$ROOTDISK" ] && continue
  for p in "$d"*[0-9]; do [ -b "$p" ] && wipefs -afq "$p" 2>/dev/null; done
  pvremove -ff -y "$d"* 2>/dev/null
  wipefs -afq "$d" 2>/dev/null
  partprobe "$d" 2>/dev/null
done

# Kill any leftover CPU/mem hog busy loops seeded by *-hog-find tasks.
pkill -9 -f 'cpuhog -c' 2>/dev/null || true
pkill -9 -f memhog 2>/dev/null || true
losetup -D 2>/dev/null
# Strip sim-added fstab lines (mountpoints, tmpfs, LABEL=, spare devs, exports)
sed -i -E '\#(/mnt/|/autohomes|/swapfile|^tmpfs|[[:space:]]tmpfs[[:space:]]|LABEL=|/dev/vd[b-z]|/exports/)#d' /etc/fstab 2>/dev/null
# Remove EVERY swap fstab line except the original root swap (rhel-swap),
# so stale UUID/LABEL swap entries can't accumulate across batches.
sed -i '/swap/{/rhel-swap/!d}' /etc/fstab 2>/dev/null
rm -rf /mnt/* /swapfile /autohomes 2>/dev/null
rm -f /var/lib/rhcsa-sim/claims/*.dev 2>/dev/null
swapon -a 2>/dev/null   # re-enable root swap
echo "clean_disks: spare disks freed ($(ls /dev/vd[b-z] 2>/dev/null | tr '\n' ' '))"
