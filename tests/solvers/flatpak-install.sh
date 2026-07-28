#!/usr/bin/env bash
# Solver for flatpak-install: install the app from the pre-configured remote.
: "${REMOTE:=localapps}"; : "${APP_ID:=com.example.HelloRHCSA}"
flatpak install --system -y "$REMOTE" "$APP_ID"
