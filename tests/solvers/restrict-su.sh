#!/usr/bin/env bash
# Uncomment an existing pam_wheel line if present, else append one.
if grep -qE '^[[:space:]]*#[[:space:]]*auth[[:space:]]+required[[:space:]]+pam_wheel\.so' /etc/pam.d/su; then
  sed -i -E 's|^[[:space:]]*#[[:space:]]*(auth[[:space:]]+required[[:space:]]+pam_wheel\.so.*)|\1|' /etc/pam.d/su
elif ! grep -vE '^[[:space:]]*#' /etc/pam.d/su | grep -qE 'auth[[:space:]]+required[[:space:]]+pam_wheel\.so'; then
  sed -i '0,/^auth/s//auth\t\trequired\tpam_wheel.so use_uid\nauth/' /etc/pam.d/su || \
    printf 'auth\t\trequired\tpam_wheel.so use_uid\n' >> /etc/pam.d/su
fi
