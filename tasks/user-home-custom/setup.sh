#!/usr/bin/env bash
# Candidate creates the user and its custom home; ensure a clean slate.
id "$U" >/dev/null 2>&1 && userdel -rf "$U" >/dev/null 2>&1
rm -rf "$HOMEDIR" 2>/dev/null
echo "user-home-custom: ready (no seeded user)"
exit 0
