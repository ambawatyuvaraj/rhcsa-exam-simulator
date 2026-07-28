#!/usr/bin/env bash
: "${REMOTE:=localapps}"
: "${APP_ID:=com.example.HelloRHCSA}"
flatpak uninstall --system -y "$APP_ID" >/dev/null 2>&1 || true
flatpak uninstall --system -y --unused >/dev/null 2>&1 || true
flatpak remote-delete --system --force "$REMOTE" >/dev/null 2>&1 || true
rm -rf /opt/rhcsa-flatpak 2>/dev/null
exit 0
