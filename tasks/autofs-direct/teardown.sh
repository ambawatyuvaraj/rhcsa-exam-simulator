#!/usr/bin/env bash
systemctl disable --now autofs >/dev/null 2>&1
umount -lf "/mnt/$MP" 2>/dev/null
rm -f /etc/auto.master.d/direct.autofs /etc/auto.direct 2>/dev/null
systemctl disable --now nfs-server >/dev/null 2>&1
sed -i '\#/exports/direct#d' /etc/exports 2>/dev/null
exportfs -ra >/dev/null 2>&1
rm -rf /exports/direct "/mnt/$MP" 2>/dev/null
exit 0
