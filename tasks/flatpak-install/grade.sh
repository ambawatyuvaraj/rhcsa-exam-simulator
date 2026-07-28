#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"

# The application is installed system-wide.
ckpt_expr "Flatpak app '$APP_ID' is installed" 7 \
  'flatpak list --system --app --columns=application 2>/dev/null | grep -qx "'"$APP_ID"'"'

# It was installed from the provided remote (not some other source).
ckpt_expr "app '$APP_ID' came from remote '$REMOTE'" 3 \
  'flatpak list --system --app --columns=application,origin 2>/dev/null |
     awk -v a="'"$APP_ID"'" "\$1==a{print \$2}" | grep -qx "'"$REMOTE"'"'
