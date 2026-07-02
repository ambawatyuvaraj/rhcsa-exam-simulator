#!/usr/bin/env bash
id wallah >/dev/null 2>&1 || useradd -m wallah
loginctl enable-linger wallah >/dev/null 2>&1
U=$(id -u wallah)
# systemctl --user needs the user runtime dir AND the session bus (linger starts
# user@UID.service which creates /run/user/UID/bus); wait for it + export DBUS.
for i in $(seq 1 20); do [ -S "/run/user/$U/bus" ] && break; systemctl start "user@$U.service" 2>/dev/null; sleep 1; done
ENV="export XDG_RUNTIME_DIR=/run/user/$U; export DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/$U/bus"
# ensure the watch image is in wallah's rootless store (load+tag from the asset if missing)
runuser -l wallah -c "$ENV; podman image exists watch:latest || podman image exists watch || { podman load -i '$RHCSA_ASSETS/rhcsa-app.tar'; podman tag localhost/rhcsa-app:latest watch:latest; }" >/dev/null 2>&1
runuser -l wallah -c "$ENV
  podman rm -f ascii2pdf 2>/dev/null
  podman run -d --name ascii2pdf -v /opt/files:/opt/dir1:Z -v /opt/progress:/opt/dir2:Z watch:latest
  mkdir -p ~/.config/systemd/user
  cd ~/.config/systemd/user && podman generate systemd --name ascii2pdf --new --files
  podman rm -f ascii2pdf 2>/dev/null
  systemctl --user daemon-reload
  systemctl --user enable --now container-ascii2pdf.service" >/dev/null 2>&1
