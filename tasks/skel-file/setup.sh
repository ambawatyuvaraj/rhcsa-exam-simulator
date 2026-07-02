#!/usr/bin/env bash
# Candidate adds the skel file; ensure a clean slate.
rm -f "/etc/skel/$F" 2>/dev/null
echo "skel-file: ready (no skel file yet)"
exit 0
