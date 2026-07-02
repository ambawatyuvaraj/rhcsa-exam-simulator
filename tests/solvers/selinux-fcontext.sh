#!/usr/bin/env bash
# Add a persistent fcontext rule for $DIR and relabel existing files
semanage fcontext -a -t httpd_sys_content_t "$DIR(/.*)?" 2>/dev/null \
  || semanage fcontext -m -t httpd_sys_content_t "$DIR(/.*)?" 2>/dev/null
restorecon -RFv "$DIR" >/dev/null 2>&1
