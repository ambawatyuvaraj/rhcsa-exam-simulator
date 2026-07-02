#!/usr/bin/env bash
# Make sure the argument isn't already present (don't do the candidate's work).
grubby --update-kernel=ALL --remove-args="$ARG" >/dev/null 2>&1 || true
echo "grub-kernelarg: ensured '$ARG' is not yet set"
exit 0
