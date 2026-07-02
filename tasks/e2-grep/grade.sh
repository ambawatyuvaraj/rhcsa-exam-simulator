#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
ckpt "/root/list exists"                     2 path_exists /root/list
# The iso-codes XML is a static file (it does not mutate like /etc/passwd), so an
# exact diff of the grep output against the candidate's file is the correct check.
ckpt_expr "contents match grep ng of the iso-codes file" 8 'diff <(grep ng /usr/share/xml/iso-codes/iso_639_3.xml) /root/list >/dev/null 2>&1'
