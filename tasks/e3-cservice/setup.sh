#!/usr/bin/env bash
command -v podman >/dev/null 2>&1 || dnf -y install podman >/dev/null 2>&1 || true
# student is the system's own login account — never create or delete it here.
id student >/dev/null 2>&1 || useradd -m student 2>/dev/null
mkdir -p /opt/files /opt/processed
chown student:student /opt/files /opt/processed
# Provide the 'monitor' image in student's rootless store. This paper has no
# build task; the answer key pulls docker.io/admin034/monitor:latest from a
# registry — offline, we stand it in from the bundled image asset, tagged
# monitor:latest.
runuser -l student -c "podman load -i '$RHCSA_ASSETS/rhcsa-app.tar'" >/dev/null 2>&1 || true
runuser -l student -c "podman tag localhost/rhcsa-app:latest monitor:latest" >/dev/null 2>&1 || true
runuser -l student -c "podman rm -f ascii2pdf" >/dev/null 2>&1 || true
echo "e3-cservice: student + /opt/files + /opt/processed + monitor image ready"
exit 0
