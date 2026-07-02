#!/usr/bin/env bash
id walhalla >/dev/null 2>&1 || useradd -m walhalla
loginctl enable-linger walhalla >/dev/null 2>&1
U=$(id -u walhalla)
# `systemctl --user` needs BOTH the user runtime dir AND the session bus. linger
# starts user@UID.service which creates /run/user/UID/bus; wait for it. Without
# DBUS_SESSION_BUS_ADDRESS the enable/start silently fail (only linger scores).
for i in $(seq 1 20); do [ -S "/run/user/$U/bus" ] && break; systemctl start "user@$U.service" 2>/dev/null; sleep 1; done
ENV="export XDG_RUNTIME_DIR=/run/user/$U; export DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/$U/bus"
# Ensure the 'monitor' image is in walhalla's rootless storage (normally built by
# the preceding f08-cbuild task; fall back to building from ~/build if present).
runuser -l walhalla -c "$ENV; podman image exists monitor || podman image exists localhost/monitor:latest || { [ -d ~/build ] && cd ~/build && podman build -t monitor . ; }" >/dev/null 2>&1
# Create the container, generate the user unit, drop the hand-run container (the
# --new unit re-creates one of the same name), then enable+start the unit.
runuser -l walhalla -c "$ENV
  podman rm -f ascii2pdf 2>/dev/null
  podman run -d --name ascii2pdf -v /opt/files:/opt/incoming:Z -v /opt/processed:/opt/outcoming:Z monitor
  mkdir -p ~/.config/systemd/user
  cd ~/.config/systemd/user && podman generate systemd --name ascii2pdf --new --files
  podman rm -f ascii2pdf 2>/dev/null
  systemctl --user daemon-reload
  systemctl --user enable --now container-ascii2pdf.service" >/dev/null 2>&1
