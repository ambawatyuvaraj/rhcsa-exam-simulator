#!/usr/bin/env bash
cut -d: -f"$F" /etc/passwd > "/root/$OUT"
