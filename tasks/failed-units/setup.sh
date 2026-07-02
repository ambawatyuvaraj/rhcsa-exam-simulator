#!/usr/bin/env bash
UNIT="rhcsa-failunit.service"
rm -f "/root/$OUT"

cat > "/etc/systemd/system/$UNIT" <<'EOF'
[Unit]
Description=RHCSA simulated failing unit

[Service]
Type=oneshot
ExecStart=/bin/false
EOF

systemctl daemon-reload >/dev/null 2>&1 || true
systemctl reset-failed "$UNIT" >/dev/null 2>&1 || true
# Start it; it will fail and land in the failed state.
systemctl start "$UNIT" >/dev/null 2>&1 || true
echo "failed-units: created and tripped '$UNIT' into the failed state"
exit 0
