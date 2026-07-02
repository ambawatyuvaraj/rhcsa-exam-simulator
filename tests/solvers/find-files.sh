#!/usr/bin/env bash
mkdir -p /root/findfiles; find / -user jacques -exec cp -a {} /root/findfiles/ \; 2>/dev/null; return 0 2>/dev/null; true
