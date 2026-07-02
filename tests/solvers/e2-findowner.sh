#!/usr/bin/env bash
id jacques >/dev/null 2>&1 || useradd jacques
mkdir -p /root/findfiles
find / -user jacques -exec cp -a {} /root/findfiles/ \; 2>/dev/null
exit 0
