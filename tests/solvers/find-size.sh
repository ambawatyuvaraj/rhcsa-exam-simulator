#!/usr/bin/env bash
find /opt/sizesrc -type f -size +10k -size -100k > "/root/$OUT"
