#!/usr/bin/env bash
# Open a TCP port permanently and in the runtime (idempotent).
firewall-cmd --permanent --add-port="$FWPORT/tcp" >/dev/null 2>&1
firewall-cmd --reload >/dev/null 2>&1
