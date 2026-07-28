#!/usr/bin/env bash
: "${REMOTE:=localapps}"
flatpak remote-delete --system --force "$REMOTE" >/dev/null 2>&1 || true
rm -rf /opt/rhcsa-flatpak 2>/dev/null
exit 0
