#!/usr/bin/env bash
command -v podman >/dev/null 2>&1 || dnf -y install podman >/dev/null 2>&1 || true
id walhalla >/dev/null 2>&1 || useradd -m walhalla
echo 'walhalla:redhat' | chpasswd 2>/dev/null   # password so you can `ssh walhalla@...` (a real login = clean rootless podman)
[ -d /home/walhalla ] || install -d -m 700 -o walhalla -g walhalla /home/walhalla
chown walhalla:walhalla /home/walhalla
mkdir -p /opt/files /opt/processed
chown walhalla:walhalla /opt/files /opt/processed
echo "f08-cservice: user walhalla + bind dirs ready (build the 'monitor' image first)"
exit 0
