#!/usr/bin/env bash
# Tear down the service + container/image, but NEVER delete the student account.
U="$(id -u student 2>/dev/null)"
if [ -n "$U" ]; then
  runuser -l student -c "export XDG_RUNTIME_DIR=/run/user/$U; systemctl --user disable --now container-ascii2pdf.service" >/dev/null 2>&1
  runuser -l student -c "podman rm -f ascii2pdf; podman rmi -f monitor:latest localhost/rhcsa-app:latest" >/dev/null 2>&1
  rm -f /home/student/.config/systemd/user/container-ascii2pdf.service 2>/dev/null
fi
loginctl disable-linger student >/dev/null 2>&1
rm -rf /opt/files /opt/processed 2>/dev/null
exit 0
