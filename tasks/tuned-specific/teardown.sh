#!/usr/bin/env bash
tuned-adm profile balanced >/dev/null 2>&1 || true
exit 0
