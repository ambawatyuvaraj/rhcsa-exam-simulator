#!/usr/bin/env bash
mkdir -p /home/manage
find /usr/bin -maxdepth 1 -type f -size -5M -exec cp {} /home/manage/ \; 2>/dev/null
