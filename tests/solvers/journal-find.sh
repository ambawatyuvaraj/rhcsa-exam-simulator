#!/usr/bin/env bash
# Save chronyd journal entries for the current boot to /root/$OUTF (idempotent).
journalctl -u chronyd -b > "/root/$OUTF"
