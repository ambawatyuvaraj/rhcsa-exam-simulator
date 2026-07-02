#!/usr/bin/env bash
rm -rf "/$DIR" 2>/dev/null
userdel -rf "$U" >/dev/null 2>&1
exit 0
