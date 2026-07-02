#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
ckpt_expr "SELinux: http_port_t includes tcp/82"   6 'semanage port -l 2>/dev/null | awk "/^http_port_t/ && /tcp/" | grep -qw 82'
ckpt_expr "firewall allows 82/tcp"                 3 'firewall-cmd --list-ports 2>/dev/null | tr " " "\n" | grep -qx 82/tcp'
ckpt "httpd is enabled at boot"                    2 svc_enabled httpd
ckpt "httpd is running"                            2 svc_active httpd
ckpt_expr "content served on http://localhost:82"  7 'curl -s -o /dev/null -w "%{http_code}" http://localhost:82 2>/dev/null | grep -qE "^(200|403|301)$"'
