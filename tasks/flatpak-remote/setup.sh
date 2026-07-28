#!/usr/bin/env bash
# Starting state: the offline Flatpak repo exists at REPO_PATH, but NO remote
# named REMOTE is configured yet, so the baseline scores 0. Idempotent.
: "${REPO_PATH:=/opt/rhcsa-flatpak/repo}"
: "${REMOTE:=localapps}"
: "${APP_ID:=com.example.HelloRHCSA}"
ASSETS="${RHCSA_ASSETS:-/opt/rhcsa-sim/assets}"

command -v flatpak >/dev/null 2>&1 || dnf -y install flatpak >/dev/null 2>&1 || true
mkdir -p "$(dirname "$REPO_PATH")"
bash "$ASSETS/build-flatpak-repo.sh" "$REPO_PATH" "$APP_ID" \
  || echo "flatpak-remote: WARN repo build failed (is flatpak installed?)" >&2

# Ensure the target remote does NOT already exist (baseline 0).
flatpak remote-delete --system "$REMOTE" >/dev/null 2>&1 || true

echo "flatpak-remote: offline repo at $REPO_PATH; add a system remote named '$REMOTE'"
exit 0
