#!/usr/bin/env bash
rm -f /etc/sysctl.d/99-rhcsa.conf
case "$KEY" in
  vm.swappiness)        sysctl -w vm.swappiness=60 >/dev/null 2>&1 || true ;;
  net.ipv4.ip_forward)  sysctl -w net.ipv4.ip_forward=0 >/dev/null 2>&1 || true ;;
esac
exit 0
