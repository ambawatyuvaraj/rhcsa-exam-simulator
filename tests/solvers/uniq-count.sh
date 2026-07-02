#!/usr/bin/env bash
sort /opt/dups.txt | uniq -c > "/root/$OUT"
