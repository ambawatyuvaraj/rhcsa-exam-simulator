#!/usr/bin/env bash
command -v podman >/dev/null 2>&1 || dnf -y install podman >/dev/null 2>&1 || true
id walhalla >/dev/null 2>&1 || useradd -m walhalla
echo 'walhalla:redhat' | chpasswd 2>/dev/null   # password so you can `ssh walhalla@...` (a real login = clean rootless podman, no cgroup warnings)
install -d -o walhalla -g walhalla /home/walhalla/build
cat > /home/walhalla/build/Containerfile <<'CF'
FROM localhost/rhcsa-app:latest
LABEL rhcsa=monitor
LABEL maintainer=walhalla
CF
chown walhalla:walhalla /home/walhalla/build/Containerfile
# base image into walhalla's rootless store (so the FROM line resolves); clear stale monitor
runuser -l walhalla -c "podman load -i '$RHCSA_ASSETS/rhcsa-app.tar'" >/dev/null 2>&1 || true
runuser -l walhalla -c "podman rmi -f monitor localhost/monitor:latest" >/dev/null 2>&1 || true
echo "f08-cbuild: Containerfile + base image ready for walhalla"
exit 0
