#!/usr/bin/env bash
# Do not pre-install the group; ensure a representative member is absent so the
# candidate must perform the install. (Best effort — never fail setup.)
# Guard: NEVER uninstall podman — it is required by every container task and
# removing it breaks them and leaves the host with no container engine. Use
# buildah as the Container Management representative instead.
case "$MEMBER" in podman) MEMBER=buildah ;; esac
dnf -y remove "$MEMBER" >/dev/null 2>&1 || true
echo "package-group: target group '$GROUPNAME' (member '$MEMBER') not installed"
exit 0
