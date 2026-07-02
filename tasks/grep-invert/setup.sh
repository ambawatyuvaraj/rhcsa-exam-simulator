#!/usr/bin/env bash
cat >/opt/invsrc.log <<'EOF'
INFO service started
ERROR disk full
DEBUG cache miss
INFO request handled
WARN low memory
ERROR timeout reached
DEBUG retry scheduled
INFO shutdown complete
WARN deprecated option
EOF
rm -f "/root/$OUT"
echo "grep-invert: seeded /opt/invsrc.log (drop lines with $PAT -> /root/$OUT)"
exit 0
