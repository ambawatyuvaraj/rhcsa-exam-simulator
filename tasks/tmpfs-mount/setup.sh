#!/usr/bin/env bash
umount "/mnt/$MP" 2>/dev/null
sed -i '\#/mnt/'"$MP"'#d' /etc/fstab 2>/dev/null
rm -rf "/mnt/$MP" 2>/dev/null
echo "tmpfs-mount: mount point /mnt/$MP cleared"
exit 0
