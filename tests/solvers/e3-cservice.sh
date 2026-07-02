#!/usr/bin/env bash
id student >/dev/null 2>&1 || useradd -m student
loginctl enable-linger student >/dev/null 2>&1
U=$(id -u student)
for i in $(seq 1 20); do [ -S "/run/user/$U/bus" ] && break; systemctl start "user@$U.service" 2>/dev/null; sleep 1; done
ENV="export XDG_RUNTIME_DIR=/run/user/$U; export DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/$U/bus"
# ensure the monitor image is present in student's rootless store
runuser -l student -c "$ENV; podman image exists monitor:latest || podman tag localhost/rhcsa-app:latest monitor:latest" >/dev/null 2>&1
runuser -l student -c "$ENV
  podman rm -f ascii2pdf 2>/dev/null
  podman run -d --name ascii2pdf -v /opt/files:/opt/incoming:Z -v /opt/processed:/opt/outgoing:Z monitor:latest
  mkdir -p ~/.config/systemd/user
  cd ~/.config/systemd/user && podman generate systemd --name ascii2pdf --new --files
  podman rm -f ascii2pdf 2>/dev/null
  systemctl --user daemon-reload
  systemctl --user enable --now container-ascii2pdf.service" >/dev/null 2>&1
