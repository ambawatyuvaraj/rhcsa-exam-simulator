#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
ckpt_expr "$NAME.service unit file exists"  3 'test -f "/etc/systemd/system/'"$NAME"'.service"'
ckpt_expr "$NAME.timer unit file exists"    3 'test -f "/etc/systemd/system/'"$NAME"'.timer"'
ckpt_expr "$NAME.timer is enabled"          3 'systemctl is-enabled "'"$NAME"'.timer" >/dev/null 2>&1'
ckpt_expr "$NAME.timer is active"           3 'systemctl is-active "'"$NAME"'.timer" >/dev/null 2>&1'
