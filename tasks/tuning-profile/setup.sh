#!/usr/bin/env bash
dnf -y install tuned >/dev/null 2>&1 || true
systemctl enable --now tuned >/dev/null 2>&1
tuned-adm profile balanced >/dev/null 2>&1   # a NON-recommended profile (VM recommends virtual-guest)
systemctl disable --now tuned >/dev/null 2>&1  # off at seed: student must enable + apply the recommended one
echo "tuning-profile: tuned present, set to a non-recommended profile and stopped"
exit 0
