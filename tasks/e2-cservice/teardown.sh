#!/usr/bin/env bash
U="$(id -u wallah 2>/dev/null)"
if [ -n "$U" ]; then
  runuser -l wallah -c "export XDG_RUNTIME_DIR=/run/user/$U; systemctl --user disable --now container-ascii2pdf.service" >/dev/null 2>&1
  runuser -l wallah -c "podman rm -f ascii2pdf; podman rmi -f watch:latest localhost/rhcsa-app:latest" >/dev/null 2>&1
fi
loginctl disable-linger wallah >/dev/null 2>&1
rm -rf /opt/files /opt/progress 2>/dev/null
exit 0
