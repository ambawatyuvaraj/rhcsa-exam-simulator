#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
ckpt_expr "kernel arg '$ARG' present on all kernels" 8 'n=$(grubby --info=ALL 2>/dev/null | grep -cE "^args="); m=$(grubby --info=ALL 2>/dev/null | grep -E "^args=" | grep -c "'"$ARG"'"); [ "$n" -gt 0 ] && [ "$n" = "$m" ]'
