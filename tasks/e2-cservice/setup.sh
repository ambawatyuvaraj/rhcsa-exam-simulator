#!/usr/bin/env bash
command -v podman >/dev/null 2>&1 || dnf -y install podman >/dev/null 2>&1 || true
id wallah >/dev/null 2>&1 || useradd -m wallah
echo 'wallah:redhat' | chpasswd 2>/dev/null   # password for ssh wallah@... (real login = clean rootless podman)
[ -d /home/wallah ] || install -d -m 700 -o wallah -g wallah /home/wallah
chown wallah:wallah /home/wallah
mkdir -p /opt/files /opt/progress
chown wallah:wallah /opt/files /opt/progress
# Provide the 'watch' image in wallah's rootless store. This paper has no build
# task; the answer key pulls it from a registry — offline, we stand it in from
# the bundled image asset and tag it watch:latest.
runuser -l wallah -c "podman load -i '$RHCSA_ASSETS/rhcsa-app.tar'" >/dev/null 2>&1 || true
runuser -l wallah -c "podman tag localhost/rhcsa-app:latest watch:latest" >/dev/null 2>&1 || true
runuser -l wallah -c "podman rm -f ascii2pdf" >/dev/null 2>&1 || true
echo "e2-cservice: wallah + /opt/files + /opt/progress + watch image ready"
exit 0
