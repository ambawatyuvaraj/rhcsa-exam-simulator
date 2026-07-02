#!/usr/bin/env bash
. "$RHCSA_LIB/storage-prep.sh"
umount -lf /mnt/database 2>/dev/null
sed -i '\#/mnt/database#d' /etc/fstab 2>/dev/null
lvremove -f datastore >/dev/null 2>&1
vgremove -f datastore >/dev/null 2>&1
rm -rf /mnt/database 2>/dev/null
shared_cleanup e1storage
exit 0
