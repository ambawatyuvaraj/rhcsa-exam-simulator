#!/usr/bin/env bash
rm -f "/root/$OUT"
# Seed a known error-priority entry into the current boot's journal.
logger -p err "rhcsa-test-err"
echo "journal-priority: logged an err-priority entry and removed any prior /root/$OUT"
exit 0
