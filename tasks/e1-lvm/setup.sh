#!/usr/bin/env bash
# LVM lives on the SHARED storage disk (the swap task uses another partition on
# the same disk). The candidate creates the datastore VG + database LV here; the
# resize task (e1-lvresize) later extends THIS same LV.
. "$RHCSA_LIB/storage-prep.sh"
dev="$(ensure_shared_disk e1storage)" || { echo "e1-lvm: could not provide a spare disk"; exit 1; }
# clean baseline: no datastore VG / mountpoint yet (candidate must create it)
umount -lf /mnt/database 2>/dev/null
vgremove -f datastore >/dev/null 2>&1 || true
rm -rf /mnt/database 2>/dev/null
echo "e1-lvm: shared storage disk = $dev (create VG 'datastore' + LV 'database' on it)"
exit 0
