#!/usr/bin/env bash
dnf -y install tuned >/dev/null 2>&1 || true
systemctl enable --now tuned >/dev/null 2>&1 || true

# Set a profile DIFFERENT from the target so the candidate must change it.
other="balanced"
[ "$PROF" = "balanced" ] && other="powersave"
tuned-adm profile "$other" >/dev/null 2>&1 || true
echo "tuned-specific: tuned enabled with profile '$other' (target is '$PROF')"
exit 0
