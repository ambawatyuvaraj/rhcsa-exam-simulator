#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"

# The system remote exists with the given name.
ckpt_expr "system Flatpak remote '$REMOTE' exists" 4 \
  'flatpak remotes --system --columns=name 2>/dev/null | grep -qx "'"$REMOTE"'"'

# It points at the provided offline repository (URL column matches REPO_PATH).
ckpt_expr "remote '$REMOTE' points at the provided repo" 4 \
  'flatpak remotes --system --columns=name,url 2>/dev/null |
     awk -v r="'"$REMOTE"'" "\$1==r{print \$2}" | grep -qF "'"$REPO_PATH"'"'

# The repo is actually usable — its app is visible through the remote.
ckpt_expr "remote '$REMOTE' is usable (app is listed)" 2 \
  'flatpak remote-ls --system "'"$REMOTE"'" 2>/dev/null | grep -qF "'"$APP_ID"'"'
