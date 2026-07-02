#!/usr/bin/env bash
# Make the journal persistent so there is on-disk data to vacuum.
mkdir -p /var/log/journal
sed -i 's/^#\?\s*Storage=.*/Storage=persistent/' /etc/systemd/journald.conf 2>/dev/null || true
grep -qE '^\s*Storage\s*=' /etc/systemd/journald.conf 2>/dev/null || echo "Storage=persistent" >> /etc/systemd/journald.conf

# Disable journald rate limiting during seeding so our filler is not dropped;
# without this, RateLimitBurst silently discards most messages and the journal
# never grows past the target (task becomes trivially already-satisfied).
mkdir -p /etc/systemd/journald.conf.d
printf '[Journal]\nRateLimitIntervalSec=0\nRateLimitBurst=0\nSystemMaxUse=500M\n' \
  > /etc/systemd/journald.conf.d/99-rhcsa-seed.conf
systemctl restart systemd-journald >/dev/null 2>&1 || true
systemd-tmpfiles --create --prefix /var/log/journal >/dev/null 2>&1 || true

# Convert SIZE (e.g. 50M) to bytes and aim for ~2x so the baseline is clearly
# ABOVE the SIZE*1.5 grading tolerance -> the candidate must actually vacuum.
size="${SIZE:-50M}"; num=${size%[MmGgKk]}; unit=${size#$num}
case "$unit" in
  G|g) sb=$((num*1024*1024*1024)) ;;
  M|m) sb=$((num*1024*1024)) ;;
  K|k) sb=$((num*1024)) ;;
  *)   sb=$num ;;
esac
target=$((sb*2))

cur_used() {
  u=$(journalctl --disk-usage 2>/dev/null | grep -oE "[0-9]+(\.[0-9]+)?[KMGT]" | head -1)
  [ -n "$u" ] || { echo 0; return; }
  v=$(printf "%s" "$u" | grep -oE "[0-9]+(\.[0-9]+)?")
  un=$(printf "%s" "$u" | grep -oE "[KMGT]" | head -1)
  awk -v v="$v" -v u="$un" 'BEGIN{m=1;if(u=="K")m=1024;else if(u=="M")m=1048576;else if(u=="G")m=1073741824;else if(u=="T")m=1099511627776;printf "%d", v*m}'
}

# Pre-build one batch file (~8000 lines of ~700 bytes) and feed it via a single
# `logger -f` per round (one process, not thousands of forks) so seeding is fast.
msg=$(printf 'rhcsa-journal-vacuum-filler-%.0s' $(seq 1 22))
bf=$(mktemp)
for i in $(seq 1 8000); do echo "$msg line-$i"; done > "$bf"
for round in $(seq 1 80); do
  logger -t rhcsa-jvac -f "$bf"
  journalctl --flush >/dev/null 2>&1 || true
  [ "$(cur_used)" -ge "$target" ] && break
done
rm -f "$bf"

# Restore normal rate limiting so the candidate's system behaves normally.
rm -f /etc/systemd/journald.conf.d/99-rhcsa-seed.conf
systemctl restart systemd-journald >/dev/null 2>&1 || true
journalctl --flush >/dev/null 2>&1 || true
# Rotate so the filler ends up in ARCHIVED journal files. `journalctl
# --vacuum-size` (what the candidate runs) only deletes archived journals, never
# the active one -- without a rotate the data sits in the active file and the
# candidate's vacuum frees 0 bytes (verified on node1).
journalctl --rotate >/dev/null 2>&1 || true
journalctl --flush >/dev/null 2>&1 || true
echo "journal-vacuum: persistent journal seeded to ~$((target/1048576))M (SIZE=$size)"
exit 0
