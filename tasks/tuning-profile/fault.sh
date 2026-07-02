#!/usr/bin/env bash
# Troubleshooting fault: switch tuned to a non-recommended profile.
rec="$(tuned-adm recommend 2>/dev/null)"
alt=powersave; [ "$rec" = powersave ] && alt=balanced
tuned-adm profile "$alt" >/dev/null 2>&1
echo "SYMPTOM: tuned is using the '$alt' profile instead of the profile recommended for this system"
