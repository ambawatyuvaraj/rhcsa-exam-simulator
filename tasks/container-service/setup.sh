#!/usr/bin/env bash
dnf -y install podman >/dev/null 2>&1 || true
id contsvc >/dev/null 2>&1 || useradd -m contsvc
# A stale /home/contsvc left by a prior run with a DIFFERENT uid would break
# rootless podman (the user couldn't write its own home). Ensure it exists and
# is owned by the current contsvc.
[ -d /home/contsvc ] || install -d -m 700 /home/contsvc
chown contsvc:contsvc /home/contsvc
mkdir -p /opt/app-in /opt/app-out
chown contsvc:contsvc /opt/app-in /opt/app-out
if [ -f "$RHCSA_ASSETS/rhcsa-app.tar" ]; then
  runuser -l contsvc -c "podman load -i '$RHCSA_ASSETS/rhcsa-app.tar'" >/dev/null 2>&1 || true
else
  # Fallback: tag a tiny base image as the expected name (best-effort, needs an image present)
  runuser -l contsvc -c "podman image exists localhost/rhcsa-app:latest || podman pull registry.access.redhat.com/ubi9/ubi-micro 2>/dev/null && podman tag registry.access.redhat.com/ubi9/ubi-micro localhost/rhcsa-app:latest" >/dev/null 2>&1 || true
fi
echo "container-service: user contsvc + image localhost/rhcsa-app:latest seeded"
exit 0
