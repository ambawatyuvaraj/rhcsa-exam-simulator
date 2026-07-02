#!/usr/bin/env bash
# Troubleshooting fault: remove the firewall allowance (runtime + permanent).
firewall-cmd --permanent --remove-service="$FWSVC" >/dev/null 2>&1
firewall-cmd --remove-service="$FWSVC" >/dev/null 2>&1
firewall-cmd --reload >/dev/null 2>&1
echo "SYMPTOM: the '$FWSVC' service is being blocked by the firewall (no rule in the runtime or permanent config)"
