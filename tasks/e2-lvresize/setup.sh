#!/usr/bin/env bash
# Pre-create the myvol VG + vo LV (~200 MiB ext4) with data, on its OWN disk
# (separate from the swap+myvg shared disk). The candidate extends vo to 300 MiB.
. "$RHCSA_LIB/storage-prep.sh"
dev="$(ensure_spare_disk)" || { echo "e2-lvresize: could not provide a spare disk"; exit 1; }
if ! vgs myvol >/dev/null 2>&1; then
  pvcreate -ff -y "$dev" >/dev/null 2>&1
  vgcreate myvol "$dev" >/dev/null 2>&1
  lvcreate -y -L 200M -n vo myvol >/dev/null 2>&1
  mkfs.ext4 -F /dev/myvol/vo >/dev/null 2>&1
fi
mkdir -p /mnt/vo
grep -q "/mnt/vo" /etc/fstab 2>/dev/null || echo "/dev/myvol/vo /mnt/vo ext4 defaults,nofail 0 0" >>/etc/fstab
mount /mnt/vo 2>/dev/null || mount -a 2>/dev/null
echo "important data do not lose" >/mnt/vo/data.txt
echo "e2-lvresize: seeded myvol/vo (200M ext4) at /mnt/vo"
exit 0
