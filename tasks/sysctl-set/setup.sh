#!/usr/bin/env bash
# Remove any prior persistence the candidate may have left, and make sure the
# runtime value is NOT already the target (best effort).
rm -f /etc/sysctl.d/99-rhcsa.conf
case "$KEY" in
  vm.swappiness)        sysctl -w vm.swappiness=60 >/dev/null 2>&1 || true ;;
  net.ipv4.ip_forward)  sysctl -w net.ipv4.ip_forward=0 >/dev/null 2>&1 || true ;;
esac
echo "sysctl-set: cleared prior persistence for '$KEY'"
exit 0
