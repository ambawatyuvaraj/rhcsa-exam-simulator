#!/usr/bin/env bash
# Solver for flatpak-remote: add the offline repo as a system remote.
: "${REMOTE:=localapps}"; : "${REPO_PATH:=/opt/rhcsa-flatpak/repo}"
flatpak remote-add --system --if-not-exists --no-gpg-verify "$REMOTE" "file://$REPO_PATH"
