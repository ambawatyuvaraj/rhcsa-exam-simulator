#!/usr/bin/env bash
# Troubleshooting fault: unmount and remove the fstab entry (the labelled
# filesystem stays intact, but it is no longer mounted or persistent).
umount "/mnt/$MP" >/dev/null 2>&1
sed -i "\\#[[:space:]]/mnt/$MP[[:space:]]#d" /etc/fstab 2>/dev/null
echo "SYMPTOM: the labelled filesystem is not mounted at /mnt/$MP and has no /etc/fstab entry"
