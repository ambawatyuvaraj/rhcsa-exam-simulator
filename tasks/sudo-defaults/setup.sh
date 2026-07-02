#!/usr/bin/env bash
rm -f /etc/sudoers.d/rhcsa-timeout 2>/dev/null
echo "sudo-defaults: ready (target timeout=$T)"
exit 0
