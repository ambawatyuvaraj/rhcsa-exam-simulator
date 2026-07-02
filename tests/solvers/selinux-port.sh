#!/usr/bin/env bash
  semanage port -a -t http_port_t -p tcp 82 2>/dev/null || semanage port -m -t http_port_t -p tcp 82
  firewall-cmd --permanent --add-port=82/tcp >/dev/null 2>&1; firewall-cmd --reload >/dev/null 2>&1
  systemctl enable --now httpd >/dev/null 2>&1
