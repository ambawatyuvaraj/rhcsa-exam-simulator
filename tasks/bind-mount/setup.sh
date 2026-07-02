#!/usr/bin/env bash
mkdir -p "/srv/$SRC"
echo "bind source data" >"/srv/$SRC/marker"
umount "/mnt/$MP" 2>/dev/null
sed -i '\#/mnt/'"$MP"'#d' /etc/fstab 2>/dev/null
rm -rf "/mnt/$MP" 2>/dev/null
echo "bind-mount: source /srv/$SRC is ready"
exit 0
