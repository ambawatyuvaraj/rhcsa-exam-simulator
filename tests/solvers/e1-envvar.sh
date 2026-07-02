#!/usr/bin/env bash
id alies >/dev/null 2>&1 || useradd -u 1326 alies
f=/home/alies/.bash_profile
touch "$f"
grep -qx 'RHCSA="Welcome to Advantage Pro"' "$f" || echo 'RHCSA="Welcome to Advantage Pro"' >> "$f"
grep -qx 'export RHCSA' "$f" || echo 'export RHCSA' >> "$f"
chown alies:alies "$f"
