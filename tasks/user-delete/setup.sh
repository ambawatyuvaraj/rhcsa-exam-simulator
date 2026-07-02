#!/usr/bin/env bash
# Seed the user WITH a home directory; the candidate deletes both.
if ! id "$U" >/dev/null 2>&1; then
  useradd -m "$U"
fi
mkdir -p "/home/$U" 2>/dev/null
echo "user-delete: seeded $U with home /home/$U"
exit 0
