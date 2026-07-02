#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
ckpt "/search exists"                              2 path_exists /search
ckpt_expr "/search lists the .conf files in /etc"  8 'diff <(find /etc -name "*.conf" 2>/dev/null | sort -u) <(sort -u /search 2>/dev/null) >/dev/null 2>&1 && [ -s /search ]'
