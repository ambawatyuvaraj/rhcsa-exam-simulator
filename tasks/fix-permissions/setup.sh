#!/usr/bin/env bash
mkdir -p "$(dirname "$TGT")"
echo content > "$TGT"
chmod 000 "$TGT"
chown nobody:nobody "$TGT" 2>/dev/null
echo "fix-permissions: seeded $TGT with broken mode/ownership"
exit 0
