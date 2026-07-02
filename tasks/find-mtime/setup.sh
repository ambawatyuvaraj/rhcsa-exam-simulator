#!/usr/bin/env bash
mkdir -p /opt/mtsrc
# Recent files (now) — these must be copied.
for f in fresh_a.txt fresh_b.txt; do printf 'recent\n' >"/opt/mtsrc/$f"; touch "/opt/mtsrc/$f"; done
# Old files — modified well beyond any DAYS choice (max 7) — must NOT be copied.
for f in old_a.txt old_b.txt; do printf 'old\n' >"/opt/mtsrc/$f"; touch -d '30 days ago' "/opt/mtsrc/$f"; done
rm -rf "/root/$OUT"
echo "find-mtime: seeded /opt/mtsrc (window ${DAYS}d -> /root/$OUT)"
exit 0
