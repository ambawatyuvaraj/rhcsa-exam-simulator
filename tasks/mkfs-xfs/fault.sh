#!/usr/bin/env bash
# Troubleshooting fault: unmount and remove the fstab entry (the XFS filesystem
# itself stays intact, but it is no longer mounted or persistent).
umount "/mnt/$MP" >/dev/null 2>&1
sed -i "\\#[[:space:]]/mnt/$MP[[:space:]]#d" /etc/fstab 2>/dev/null
echo "SYMPTOM: nothing is mounted at /mnt/$MP and /etc/fstab has no entry for it (it will not come back after a reboot)"
