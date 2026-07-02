#!/usr/bin/env bash
# Candidate creates the user; ensure a clean slate so a re-run grades fairly.
id "$U" >/dev/null 2>&1 && userdel -rf "$U" >/dev/null 2>&1
echo "user-create-comment: ready (no seeded user)"
exit 0
