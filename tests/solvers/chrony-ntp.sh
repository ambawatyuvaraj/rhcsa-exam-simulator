#!/usr/bin/env bash
  grep -q "time.example.com" /etc/chrony.conf || echo "server time.example.com iburst" >>/etc/chrony.conf
  systemctl enable --now chronyd >/dev/null 2>&1
