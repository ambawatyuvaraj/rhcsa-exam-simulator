#!/usr/bin/env bash
id manalo >/dev/null 2>&1 && userdel -rf manalo >/dev/null 2>&1
echo "user-uid: ready"
exit 0
