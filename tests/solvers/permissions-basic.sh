#!/usr/bin/env bash
# Set octal mode and root:root ownership on the target file.
chown root:root "$TGT" 2>/dev/null
chmod "$MODE" "$TGT" 2>/dev/null
