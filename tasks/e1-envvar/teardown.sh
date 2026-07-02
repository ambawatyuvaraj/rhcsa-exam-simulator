#!/usr/bin/env bash
# Idempotent: just strip the RHCSA assignment/export from alies's profile.
# Leave the user account in place (it may be owned by another task / pre-exist).
f=/home/alies/.bash_profile
if [ -f "$f" ]; then
  sed -i -E '/^[[:space:]]*(export[[:space:]]+)?RHCSA([[:space:]]*=.*)?$/d' "$f" 2>/dev/null
fi
exit 0
