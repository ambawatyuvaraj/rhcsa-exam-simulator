#!/usr/bin/env bash
systemctl disable --now autofs >/dev/null 2>&1
umount -lf /localhome/production5 2>/dev/null
rm -rf /localhome 2>/dev/null
systemctl disable --now nfs-server >/dev/null 2>&1
sed -i '\#/exports/localhome#d' /etc/exports 2>/dev/null
exportfs -ra >/dev/null 2>&1
userdel -rf production5 >/dev/null 2>&1
rm -rf /exports 2>/dev/null
# Remove the autofs map entries the candidate/solver added so they don't persist
# or pile up across attempts in the shared /etc/auto.* files (+ drop-in style).
sed -i '/^[[:space:]]*production5[[:space:]]/d' /etc/auto.misc 2>/dev/null
sed -i '\#^[[:space:]]*/localhome[[:space:]]#d' /etc/auto.master 2>/dev/null
rm -f /etc/auto.master.d/localhome.autofs /etc/auto.localhome 2>/dev/null
exit 0
