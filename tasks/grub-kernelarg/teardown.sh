#!/usr/bin/env bash
grubby --update-kernel=ALL --remove-args="$ARG" >/dev/null 2>&1 || true
exit 0
