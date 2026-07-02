#!/usr/bin/env bash
# Candidate configures the umask; ensure a clean slate for our drop-in file.
rm -f /etc/profile.d/rhcsa-umask.sh 2>/dev/null
echo "umask-systemwide: ready"
exit 0
