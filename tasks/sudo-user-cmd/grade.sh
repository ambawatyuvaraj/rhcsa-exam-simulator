#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
ckpt "User '$U' exists"                               2 user_exists "$U"
ckpt_expr "$U has NOPASSWD rule for /usr/bin/systemctl" 5 'grep -rhE "^[[:space:]]*$U[[:space:]]+ALL=\((ALL|root)(:ALL)?\)[[:space:]]+NOPASSWD:[[:space:]]*/usr/bin/systemctl[[:space:]]*\$" /etc/sudoers /etc/sudoers.d/ 2>/dev/null | grep -q .'
ckpt_expr "sudoers configuration is syntactically valid" 3 'visudo -c >/dev/null 2>&1'
