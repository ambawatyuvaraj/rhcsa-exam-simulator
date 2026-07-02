#!/usr/bin/env bash
id simone >/dev/null 2>&1 || useradd simone
mkdir -p /root/found
find / -xdev -user simone -exec cp {} /root/found \; 2>/dev/null
