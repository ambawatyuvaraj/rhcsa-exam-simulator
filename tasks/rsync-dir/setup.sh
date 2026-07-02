#!/usr/bin/env bash
dnf -y install rsync >/dev/null 2>&1 || true

# Seed the source directory (idempotent: recreate cleanly).
rm -rf /opt/rsrc
mkdir -p /opt/rsrc/sub
echo "alpha file" > /opt/rsrc/alpha.txt
echo "beta file"  > /opt/rsrc/beta.txt
echo "nested"     > /opt/rsrc/sub/nested.txt

# Ensure destination parent exists but the copy does not.
mkdir -p "$DEST"
rm -rf "$DEST/rsrc"
echo "rsync-dir: seeded /opt/rsrc and prepared destination $DEST"
exit 0
