#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
ckpt_expr "$F has the default httpd content type" 8 \
  'ls -Z /var/www/html/'"$F"' 2>/dev/null | grep -q httpd_sys_content_t'
