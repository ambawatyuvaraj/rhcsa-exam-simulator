#!/usr/bin/env bash
# Seed the group; the candidate writes the sudoers rule.
groupadd -f "$G"
rm -f "/etc/sudoers.d/$G" 2>/dev/null
echo "sudo-group-passwd: group $G ready"
exit 0
