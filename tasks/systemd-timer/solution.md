# Reference solution — systemd timer every 15 minutes

A systemd timer needs two units: a `.service` (WHAT to run) and a `.timer` (WHEN).
`OnUnitActiveSec=15min` repeats 15 minutes after each run; you enable the `.timer`
(not the service) to schedule it.

```bash
cat > /etc/systemd/system/<NAME>.service <<'EOF'
[Unit]
Description=NAME oneshot job

[Service]
Type=oneshot
ExecStart=/usr/bin/logger tmr
EOF

cat > /etc/systemd/system/<NAME>.timer <<'EOF'
[Unit]
Description=Run NAME every 15 minutes

[Timer]
OnUnitActiveSec=15min
OnBootSec=15min

[Install]
WantedBy=timers.target
EOF

systemctl daemon-reload                  # reload unit files from disk
systemctl enable --now <NAME>.timer      # schedule + start the timer
systemctl list-timers <NAME>.timer       # verify it is scheduled
```
