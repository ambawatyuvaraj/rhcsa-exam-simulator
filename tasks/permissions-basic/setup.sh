#!/usr/bin/env bash
echo content > "$TGT"
chown root:root "$TGT"
chmod 777 "$TGT"
echo "permissions-basic: created $TGT mode 777 owned by root:root"
exit 0
