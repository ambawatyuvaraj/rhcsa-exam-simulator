#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
ckpt "httpd is enabled and active"               4 svc_ok httpd
ckpt_expr "repository metadata exists"           4 '[ -f /var/www/html/pkgrepo/repodata/repomd.xml ]'
ckpt_expr "repomd.xml is served over HTTP"       4 \
  "curl -s -o /dev/null -w '%{http_code}' http://localhost/pkgrepo/repodata/repomd.xml | grep -qx 200"
ckpt "firewall permits http"                     2 firewall_service http
