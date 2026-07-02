#!/usr/bin/env bash
# Troubleshooting fault: strip the set-GID bit and reset group ownership to root.
chmod g-s "/$DIR" >/dev/null 2>&1
chgrp root "/$DIR" >/dev/null 2>&1
echo "SYMPTOM: /$DIR lost its set-GID bit and its group ownership, so new files no longer inherit the team group"
