#!/usr/bin/env bash
. "$RHCSA_LIB/params.sh"
key="$(rand_choice vm.swappiness net.ipv4.ip_forward)"
echo "KEY=$key"
case "$key" in
  vm.swappiness)       echo "VAL=$(rand_choice 10 20 30)" ;;
  net.ipv4.ip_forward) echo "VAL=1" ;;
esac
