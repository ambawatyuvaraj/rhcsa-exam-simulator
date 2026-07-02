#!/usr/bin/env bash
. "$RHCSA_LIB/storage-prep.sh"
umount -lf /mnt/mydata 2>/dev/null
sed -i '\#/mnt/mydata#d' /etc/fstab 2>/dev/null
lvremove -f myvg >/dev/null 2>&1
vgremove -f myvg >/dev/null 2>&1
rm -rf /mnt/mydata 2>/dev/null
shared_cleanup e2storage
exit 0
