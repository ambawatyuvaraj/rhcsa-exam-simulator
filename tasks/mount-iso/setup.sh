#!/usr/bin/env bash
dnf -y install xorriso >/dev/null 2>&1 || true
mkdir -p /opt/isosrc
echo hello >/opt/isosrc/readme
[ -f "/root/$ISO.iso" ] || xorrisofs -o "/root/$ISO.iso" /opt/isosrc >/dev/null 2>&1
umount "/mnt/$MP" 2>/dev/null
sed -i '\#/mnt/'"$MP"'#d' /etc/fstab 2>/dev/null
rm -rf "/mnt/$MP" 2>/dev/null
echo "mount-iso: image /root/$ISO.iso is ready"
exit 0
