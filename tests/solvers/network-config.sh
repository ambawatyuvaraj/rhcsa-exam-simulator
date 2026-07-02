#!/usr/bin/env bash
  nmcli con delete rhcsa0 >/dev/null 2>&1
  nmcli con add type ethernet ifname rhcsa0 con-name rhcsa0 ipv4.method manual \
    ipv4.addresses 172.25.250.100/24 ipv4.gateway 172.25.250.254 ipv4.dns 172.25.250.254 \
    connection.autoconnect yes >/dev/null 2>&1
  nmcli con up rhcsa0 >/dev/null 2>&1 || true
