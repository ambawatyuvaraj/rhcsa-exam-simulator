#!/usr/bin/env bash
setsebool -P "$SB" off >/dev/null 2>&1 || true
exit 0
