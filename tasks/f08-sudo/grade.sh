#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
ckpt_expr "a NOPASSWD rule for %admin exists" 7 'grep -rhE "^[[:space:]]*%admin[[:space:]]+ALL=\(ALL(:ALL)?\)[[:space:]]+NOPASSWD:[[:space:]]*ALL" /etc/sudoers /etc/sudoers.d/ 2>/dev/null | grep -q .'
  ckpt_expr "sudoers configuration is syntactically valid" 3 'visudo -c >/dev/null 2>&1 && grep -rhE "^[[:space:]]*%admin[[:space:]]+ALL=" /etc/sudoers /etc/sudoers.d/ 2>/dev/null | grep -q .'
