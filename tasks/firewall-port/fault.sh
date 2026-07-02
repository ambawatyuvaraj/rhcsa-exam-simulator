#!/usr/bin/env bash
# Troubleshooting fault: remove the open port (runtime + permanent).
firewall-cmd --permanent --remove-port="$FWPORT/tcp" >/dev/null 2>&1
firewall-cmd --remove-port="$FWPORT/tcp" >/dev/null 2>&1
firewall-cmd --reload >/dev/null 2>&1
echo "SYMPTOM: TCP port $FWPORT is blocked by the firewall (no rule in the runtime or permanent config)"
