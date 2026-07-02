#!/usr/bin/env bash
dnf -y install at >/dev/null 2>&1 || true
systemctl enable --now atd >/dev/null 2>&1
rm -f /root/$F
for j in $(atq 2>/dev/null | awk '{print $1}'); do atrm $j 2>/dev/null; done
echo "at-job: atd ready, queue cleared"
exit 0
