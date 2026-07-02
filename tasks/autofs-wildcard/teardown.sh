#!/usr/bin/env bash
systemctl disable --now autofs >/dev/null 2>&1
umount -lf /autohomes/u1 /autohomes/u2 2>/dev/null
rm -rf /autohomes 2>/dev/null
rm -f /etc/auto.master.d/homes.autofs /etc/auto.homes 2>/dev/null
systemctl disable --now nfs-server >/dev/null 2>&1
sed -i '\#/exports/homes#d' /etc/exports 2>/dev/null
exportfs -ra >/dev/null 2>&1
rm -rf /exports/homes 2>/dev/null
exit 0
