#!/usr/bin/env bash
rm -f "/etc/sudoers.d/$G" 2>/dev/null
getent group "$G" >/dev/null 2>&1 && groupdel "$G" >/dev/null 2>&1
exit 0
