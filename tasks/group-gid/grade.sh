#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
ckpt "Group '$G' exists"            4 group_exists "$G"
ckpt_expr "$G has GID $GID"         4 '[ "$(getent group "$G" | cut -d: -f3)" = "$GID" ]'
