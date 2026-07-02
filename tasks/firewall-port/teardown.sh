#!/usr/bin/env bash
firewall-cmd --permanent --remove-port="$FWPORT"/tcp >/dev/null 2>&1
firewall-cmd --reload >/dev/null 2>&1
exit 0
