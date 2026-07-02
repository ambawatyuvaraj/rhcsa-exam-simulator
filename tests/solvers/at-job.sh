#!/usr/bin/env bash
# Schedule a one-time at job that runs touch /root/$F (idempotent).
for j in $(atq 2>/dev/null | awk '{print $1}'); do
  at -c "$j" 2>/dev/null | grep -q "/root/$F" && exit 0
done
at now + 1 hour <<EOF
/bin/touch /root/$F
EOF
