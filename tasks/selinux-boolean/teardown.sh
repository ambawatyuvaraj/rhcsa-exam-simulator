#!/usr/bin/env bash
setsebool -P "$SBOOL" off >/dev/null 2>&1 || true
exit 0
