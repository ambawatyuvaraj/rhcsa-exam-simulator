#!/usr/bin/env bash
for j in $(atq 2>/dev/null | awk '{print $1}'); do atrm $j 2>/dev/null; done
rm -f /root/$F
exit 0
