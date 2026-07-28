#!/usr/bin/env bash
# Starting state: the offline repo exists AND the system remote REMOTE is
# already configured, but the app is NOT installed, so the baseline scores 0.
: "${REPO_PATH:=/opt/rhcsa-flatpak/repo}"
: "${REMOTE:=localapps}"
: "${APP_ID:=com.example.HelloRHCSA}"
ASSETS="${RHCSA_ASSETS:-/opt/rhcsa-sim/assets}"

command -v flatpak >/dev/null 2>&1 || dnf -y install flatpak >/dev/null 2>&1 || true
mkdir -p "$(dirname "$REPO_PATH")"
bash "$ASSETS/build-flatpak-repo.sh" "$REPO_PATH" "$APP_ID" \
  || echo "flatpak-install: WARN repo build failed" >&2

# Pre-add the remote (this task is about installing, not configuring access).
flatpak remote-delete --system --force "$REMOTE" >/dev/null 2>&1 || true
flatpak remote-add --system --no-gpg-verify "$REMOTE" "file://$REPO_PATH" >/dev/null 2>&1 || true

# Ensure the app is NOT already installed (baseline 0).
flatpak uninstall --system -y "$APP_ID" >/dev/null 2>&1 || true

echo "flatpak-install: remote '$REMOTE' configured; install app '$APP_ID' from it"
exit 0
