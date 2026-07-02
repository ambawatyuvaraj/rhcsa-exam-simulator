#!/usr/bin/env bash
# Allow a service permanently and in the runtime (idempotent).
firewall-cmd --permanent --add-service="$FWSVC" >/dev/null 2>&1
firewall-cmd --reload >/dev/null 2>&1
