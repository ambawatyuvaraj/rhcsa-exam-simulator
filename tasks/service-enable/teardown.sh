#!/usr/bin/env bash
systemctl disable --now "$SVC" >/dev/null 2>&1
exit 0
