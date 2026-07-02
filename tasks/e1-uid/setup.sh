#!/usr/bin/env bash
# Ensure a clean slate so the task is NOT already satisfied; the candidate creates alies.
id alies >/dev/null 2>&1 && userdel -rf alies >/dev/null 2>&1
# Signal the env-var task in THIS session that the candidate creates alies HERE, so it
# must not pre-seed alies (keeps this baseline clean and lets `useradd alies` succeed).
mkdir -p /run/rhcsa-sim 2>/dev/null && : >/run/rhcsa-sim/user-uid.active 2>/dev/null
echo "user-uid: ready"
exit 0
