#!/usr/bin/env bash
# LVM lives on the SHARED storage disk (the swap task uses another partition on
# the same disk — faithful to the answer key's single /dev/vdb).
. "$RHCSA_LIB/storage-prep.sh"
dev="$(ensure_shared_disk e2storage)" || { echo "e2-lvm: could not provide a spare disk"; exit 1; }
umount -lf /mnt/mydata 2>/dev/null
vgremove -f myvg >/dev/null 2>&1 || true
rm -rf /mnt/mydata 2>/dev/null
echo "e2-lvm: shared storage disk = $dev (create VG 'myvg' + LV 'mylv' on it)"
exit 0
