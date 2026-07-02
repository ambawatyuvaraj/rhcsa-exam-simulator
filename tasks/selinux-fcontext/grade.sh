#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
ckpt_expr "persistent fcontext rule for $DIR" 5 \
  'semanage fcontext -l 2>/dev/null | grep -E "^'"$DIR"'" | grep -q httpd_sys_content_t'
ckpt_expr "files relabeled to httpd_sys_content_t" 5 \
  'ls -Z '"$DIR"'/index.html 2>/dev/null | grep -q httpd_sys_content_t'
