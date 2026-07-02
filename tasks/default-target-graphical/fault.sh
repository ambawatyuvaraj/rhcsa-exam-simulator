#!/usr/bin/env bash
# Troubleshooting fault: set the wrong default boot target.
systemctl set-default multi-user.target >/dev/null 2>&1
echo "SYMPTOM: the system's default boot target is multi-user.target, not graphical.target"
