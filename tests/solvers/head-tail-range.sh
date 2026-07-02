#!/usr/bin/env bash
sed -n "${A},${B}p" /etc/services > "/root/$OUT"
