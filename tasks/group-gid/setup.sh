#!/usr/bin/env bash
# Candidate creates the group; ensure a clean slate (remove a stale group of the
# same name and free the target GID if some other group is using it).
getent group "$G" >/dev/null 2>&1 && groupdel "$G" >/dev/null 2>&1
stale="$(getent group "$GID" | cut -d: -f1)"
[ -n "$stale" ] && groupdel "$stale" >/dev/null 2>&1
echo "group-gid: ready (no seeded group)"
exit 0
