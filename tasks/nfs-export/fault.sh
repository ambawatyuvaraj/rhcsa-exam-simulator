#!/usr/bin/env bash
# Troubleshooting fault: remove the export definition and stop the NFS server
# (the remoteu account and its home stay in place).
rm -f /etc/exports.d/nodeshare.exports >/dev/null 2>&1
exportfs -ra >/dev/null 2>&1
systemctl stop nfs-server >/dev/null 2>&1
echo "SYMPTOM: /exports/nodeshare is no longer exported and the NFS server is not running"
