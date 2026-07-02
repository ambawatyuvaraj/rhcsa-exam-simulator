#!/usr/bin/env bash
. "$RHCSA_LIB/storage-prep.sh"
dev="$(ensure_spare_disk)" || { echo "lvm-resize: could not provide a spare disk"; exit 1; }
# Build the pre-existing vgroup/vo (192 MiB ext4) mounted at /mnt/vo with data.
if ! vgs vgroup >/dev/null 2>&1; then
  pvcreate -ff -y "$dev" >/dev/null 2>&1
  vgcreate vgroup "$dev" >/dev/null 2>&1
  lvcreate -y -L 192M -n vo vgroup >/dev/null 2>&1
  mkfs.ext4 -F /dev/vgroup/vo >/dev/null 2>&1
fi
mkdir -p /mnt/vo
grep -q "/mnt/vo" /etc/fstab 2>/dev/null || \
  echo "/dev/vgroup/vo /mnt/vo ext4 defaults,nofail 0 0" >>/etc/fstab
mount /mnt/vo 2>/dev/null || mount -a 2>/dev/null
echo "important data do not lose" >/mnt/vo/data.txt
echo "lvm-resize: seeded vgroup/vo (192M ext4) at /mnt/vo"
exit 0
