#!/usr/bin/env bash
# Terminate the runaway process tagged with $MARK (idempotent).
# Guard: refuse a blanket pkill on an empty pattern (would kill every process,
# sshd included). This is exactly the failure that took down an audit run.
[ -n "$MARK" ] || { echo "kill-process solver: MARK unset, refusing blanket pkill" >&2; exit 1; }
pkill -f "$MARK" 2>/dev/null
sleep 1 2>/dev/null
pkill -9 -f "$MARK" 2>/dev/null
exit 0
