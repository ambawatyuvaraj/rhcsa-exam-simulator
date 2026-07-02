#!/usr/bin/env bash
# Ensure a clean slate so the task is NOT already satisfied; the candidate creates manalo.
id manalo >/dev/null 2>&1 && userdel -rf manalo >/dev/null 2>&1
echo "user-uid: ready"
exit 0
