#!/usr/bin/env bash
systemctl disable --now autofs >/dev/null 2>&1
umount -lf /rhome/remoteuser1 2>/dev/null
rm -rf /rhome 2>/dev/null
systemctl disable --now nfs-server >/dev/null 2>&1
sed -i '\#/exports/rhome#d' /etc/exports 2>/dev/null
exportfs -ra >/dev/null 2>&1
userdel -rf remoteuser1 >/dev/null 2>&1
rm -rf /exports 2>/dev/null
# Remove the autofs map entries the candidate/solver added so they don't persist
# or pile up across attempts in the shared /etc/auto.* files (+ drop-in style).
sed -i '/^[[:space:]]*remoteuser1[[:space:]]/d' /etc/auto.misc 2>/dev/null
sed -i '\#^[[:space:]]*/rhome[[:space:]]#d' /etc/auto.master 2>/dev/null
rm -f /etc/auto.master.d/rhome.autofs /etc/auto.rhome 2>/dev/null
exit 0
