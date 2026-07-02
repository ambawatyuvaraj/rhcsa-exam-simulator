#!/usr/bin/env bash
systemctl disable --now autofs >/dev/null 2>&1
umount -lf /rhome/remoteu 2>/dev/null
rm -f /etc/auto.master.d/rhome.autofs /etc/auto.rhome 2>/dev/null
rm -rf /rhome 2>/dev/null
userdel -f remoteu >/dev/null 2>&1
exit 0
