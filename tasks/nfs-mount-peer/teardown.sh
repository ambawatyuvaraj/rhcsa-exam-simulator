#!/usr/bin/env bash
umount -lf /mnt/peernfs 2>/dev/null
sed -i '\#/mnt/peernfs#d' /etc/fstab 2>/dev/null
rmdir /mnt/peernfs 2>/dev/null
exit 0
