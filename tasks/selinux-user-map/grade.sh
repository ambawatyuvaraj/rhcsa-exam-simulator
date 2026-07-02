#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
ckpt_expr "$U is mapped to SELinux user staff_u" 8 \
  "semanage login -l 2>/dev/null | awk '\$1==\"$U\"{print \$2}' | grep -qx staff_u"
