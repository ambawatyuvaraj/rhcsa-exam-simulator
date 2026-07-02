#!/usr/bin/env bash
systemctl disable "$SVC" >/dev/null 2>&1 || true
exit 0
