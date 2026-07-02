#!/usr/bin/env bash
# Ensure no pre-existing entry for the target hostname.
sed -i "/$HN/d" /etc/hosts 2>/dev/null
echo "hosts-entry: ensured no prior entry for $HN"
exit 0
