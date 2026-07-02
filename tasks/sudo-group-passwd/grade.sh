#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
ckpt "Group '$G' exists"                              2 group_exists "$G"
# Standard %group ALL=(ALL) ALL rule, and NOT NOPASSWD.
ckpt_expr "%$G has full sudo with password required"  5 'grep -rhE "^[[:space:]]*%$G[[:space:]]+ALL=\(ALL(:ALL)?\)[[:space:]]+ALL[[:space:]]*\$" /etc/sudoers /etc/sudoers.d/ 2>/dev/null | grep -q . && ! grep -rhE "^[[:space:]]*%$G[[:space:]].*NOPASSWD" /etc/sudoers /etc/sudoers.d/ 2>/dev/null | grep -q .'
ckpt_expr "sudoers configuration is syntactically valid" 3 'visudo -c >/dev/null 2>&1'
