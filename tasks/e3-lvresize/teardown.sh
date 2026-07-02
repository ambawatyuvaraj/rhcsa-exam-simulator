#!/usr/bin/env bash
. "$RHCSA_LIB/storage-prep.sh"
umount -lf /mnt/education 2>/dev/null
sed -i '\#/mnt/education#d' /etc/fstab 2>/dev/null
lvremove -f datastore >/dev/null 2>&1
vgremove -f datastore >/dev/null 2>&1
rm -rf /mnt/education 2>/dev/null
shared_cleanup e3storage
exit 0
