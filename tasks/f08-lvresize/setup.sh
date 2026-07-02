#!/usr/bin/env bash
. "$RHCSA_LIB/storage-prep.sh"
dev="$(ensure_spare_disk)" || { echo "lvm-resize: could not provide a spare disk"; exit 1; }
# Build the pre-existing wgroup/wlogic (192 MiB ext4) mounted at /mnt/wlogic with data.
if ! vgs wgroup >/dev/null 2>&1; then
  pvcreate -ff -y "$dev" >/dev/null 2>&1
  vgcreate wgroup "$dev" >/dev/null 2>&1
  lvcreate -y -L 300M -n wlogic wgroup >/dev/null 2>&1
  mkfs.ext4 -F /dev/wgroup/wlogic >/dev/null 2>&1
fi
mkdir -p /mnt/wlogic
grep -q "/mnt/wlogic" /etc/fstab 2>/dev/null || \
  echo "/dev/wgroup/wlogic /mnt/wlogic ext4 defaults,nofail 0 0" >>/etc/fstab
mount /mnt/wlogic 2>/dev/null || mount -a 2>/dev/null
echo "important data do not lose" >/mnt/wlogic/data.txt
echo "lvm-resize: seeded wgroup/wlogic (300M ext4) at /mnt/wlogic"
exit 0
