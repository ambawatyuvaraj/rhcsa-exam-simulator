#!/usr/bin/env bash
rm -f "/etc/sudoers.d/$U" 2>/dev/null
id "$U" >/dev/null 2>&1 && userdel -rf "$U" >/dev/null 2>&1
exit 0
