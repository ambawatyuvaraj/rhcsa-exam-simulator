#!/usr/bin/env bash
# Clear any existing pretty hostname so the candidate must set it.
hostnamectl set-hostname --pretty "" 2>/dev/null
echo "hostname-pretty: pretty hostname cleared"
exit 0
