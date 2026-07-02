#!/usr/bin/env bash
id alies >/dev/null 2>&1 && userdel -rf alies >/dev/null 2>&1
rm -f /run/rhcsa-sim/user-uid.active 2>/dev/null
exit 0
