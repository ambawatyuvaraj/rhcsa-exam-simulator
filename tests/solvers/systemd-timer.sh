cat > "/etc/systemd/system/$NAME.service" <<EOF
[Unit]
Description=$NAME oneshot job

[Service]
Type=oneshot
ExecStart=/usr/bin/logger tmr
EOF

cat > "/etc/systemd/system/$NAME.timer" <<EOF
[Unit]
Description=Run $NAME every 15 minutes

[Timer]
OnUnitActiveSec=15min
OnBootSec=15min

[Install]
WantedBy=timers.target
EOF

systemctl daemon-reload
systemctl enable --now "$NAME.timer"
