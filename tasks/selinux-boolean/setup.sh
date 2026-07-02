#!/usr/bin/env bash
setsebool -P "$SBOOL" off >/dev/null 2>&1 || true
echo "selinux-boolean: seeded '$SBOOL' to off"
exit 0
