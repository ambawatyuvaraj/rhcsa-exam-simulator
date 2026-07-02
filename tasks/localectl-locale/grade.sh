#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
ckpt_expr "system locale LANG is $LC" 8 'localectl status 2>/dev/null | grep -q "LANG=$LC" || grep -q "^LANG=$LC$" /etc/locale.conf 2>/dev/null'
