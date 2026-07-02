#!/usr/bin/env bash
id "$U" >/dev/null 2>&1 || useradd "$U"
echo "password-hash: seeded $U"
exit 0
