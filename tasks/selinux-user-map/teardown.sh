#!/usr/bin/env bash
semanage login -d "$U" 2>/dev/null
userdel -rf "$U" >/dev/null 2>&1
exit 0
