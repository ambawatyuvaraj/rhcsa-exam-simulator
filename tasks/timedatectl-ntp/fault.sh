#!/usr/bin/env bash
# Troubleshooting fault: turn automatic NTP synchronisation off.
timedatectl set-ntp false >/dev/null 2>&1
echo "SYMPTOM: automatic NTP time synchronisation is turned off (timedatectl reports NTP service: inactive)"
