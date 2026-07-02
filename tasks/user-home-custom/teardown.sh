#!/usr/bin/env bash
id "$U" >/dev/null 2>&1 && userdel -rf "$U" >/dev/null 2>&1
rm -rf "$HOMEDIR" 2>/dev/null
exit 0
