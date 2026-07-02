#!/usr/bin/env bash
# Troubleshooting fault: stop and disable the service that should run at boot.
systemctl disable --now "$SVC" >/dev/null 2>&1
echo "SYMPTOM: the '$SVC' service is not running, and it will not start at the next boot"
