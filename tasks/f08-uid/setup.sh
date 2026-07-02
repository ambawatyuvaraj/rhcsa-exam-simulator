#!/usr/bin/env bash
id jean >/dev/null 2>&1 && userdel -rf jean >/dev/null 2>&1
echo "user-uid: ready"
exit 0
