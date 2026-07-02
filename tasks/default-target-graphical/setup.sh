#!/usr/bin/env bash
systemctl set-default multi-user.target >/dev/null 2>&1 || true
echo "default-target-graphical: default target set to multi-user.target"
exit 0
