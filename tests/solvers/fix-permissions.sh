#!/usr/bin/env bash
# Fix mode and ownership of the target file (idempotent).
chmod "$MODE" "$TGT"
chown root:root "$TGT"
