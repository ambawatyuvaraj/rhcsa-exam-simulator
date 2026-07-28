#!/usr/bin/env bash
# build-flatpak-repo.sh <repo-dir> <app-id>
# Build a small, FULLY OFFLINE ostree-backed Flatpak repo (one runtime + one
# app) that a candidate can add as a remote and install from — no internet, no
# Red Hat subscription, no Flathub. This is flatpak's own test-suite method
# (tests/make-test-runtime.sh / make-test-app.sh): commit a hand-made tree with
# `flatpak build-export`, so we don't need a pre-existing base runtime.
# Idempotent: rebuilds the repo from scratch each call.
set -u
REPO="${1:?usage: build-flatpak-repo.sh <repo-dir> <app-id>}"
APP="${2:?app id required}"
ARCH="$(flatpak --default-arch 2>/dev/null || echo x86_64)"
BR=el10
RT=org.rhcsa.Platform

command -v flatpak >/dev/null 2>&1 || dnf -y install flatpak >/dev/null 2>&1 || true
rm -rf "$REPO"
tmp="$(mktemp -d)"; trap 'rm -rf "$tmp"' EXIT

# --- minimal runtime (files/ + usr/ + [Runtime]; no base runtime needed) ---
mkdir -p "$tmp/rt/files" "$tmp/rt/usr"
printf '[Runtime]\nname=%s\n' "$RT" > "$tmp/rt/metadata"
flatpak build-export --no-update-summary --disable-sandbox --runtime --arch="$ARCH" \
        "$REPO" "$tmp/rt" "$BR" >/dev/null 2>&1 || exit 1

# --- app that depends on that runtime ---
mkdir -p "$tmp/app/files/bin"
printf '#!/bin/sh\necho "%s (RHCSA lab flatpak)"\n' "$APP" > "$tmp/app/files/bin/hello.sh"
chmod +x "$tmp/app/files/bin/hello.sh"
cat > "$tmp/app/metadata" <<M
[Application]
name=$APP
runtime=$RT/$ARCH/$BR
sdk=$RT/$ARCH/$BR
M
flatpak build-finish --command=hello.sh "$tmp/app" >/dev/null 2>&1 || exit 1
flatpak build-export --no-update-summary --disable-sandbox --arch="$ARCH" \
        "$REPO" "$tmp/app" "$BR" >/dev/null 2>&1 || exit 1

flatpak build-update-repo "$REPO" >/dev/null 2>&1 || exit 1
exit 0
