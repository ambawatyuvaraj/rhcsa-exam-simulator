#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
ckpt_expr "/var/www/html/$F2 exists" 2 \
  '[ -f /var/www/html/'"$F2"' ]'
ckpt_expr "/var/www/html/$F2 has httpd_sys_content_t" 4 \
  'ls -Z /var/www/html/'"$F2"' 2>/dev/null | grep -q httpd_sys_content_t'
