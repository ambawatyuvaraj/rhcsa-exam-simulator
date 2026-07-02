#!/usr/bin/env bash
  id contsvc >/dev/null 2>&1 || useradd contsvc
  grep -q "^contsvc:" /etc/subuid || usermod --add-subuids 200000-265535 --add-subgids 200000-265535 contsvc
  loginctl enable-linger contsvc; local UC RD; UC=$(id -u contsvc); RD="/run/user/$UC"
  for i in 1 2 3 4 5; do [ -d "$RD" ] && break; sleep 1; done
  runuser -u contsvc -- env HOME=/home/contsvc XDG_RUNTIME_DIR="$RD" \
    DBUS_SESSION_BUS_ADDRESS="unix:path=$RD/bus" bash -lc '
    cd ~; podman rm -f rhcsa >/dev/null 2>&1
    podman run -d --name rhcsa -v /opt/app-in:/opt/incoming:Z -v /opt/app-out:/opt/outgoing:Z localhost/rhcsa-app:latest >/dev/null 2>&1
    mkdir -p ~/.config/systemd/user
    cd ~/.config/systemd/user && podman generate systemd --name rhcsa --new --files >/dev/null 2>&1
    podman rm -f rhcsa >/dev/null 2>&1
    systemctl --user daemon-reload
    systemctl --user enable --now container-rhcsa.service >/dev/null 2>&1'
