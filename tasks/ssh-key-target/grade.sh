#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
ckpt "user deploy exists"                3 user_exists deploy
ckpt_expr "deploy has a home directory"  1 '[ -d /home/deploy ]'
ckpt "deploy password is Redhat123"      3 user_password deploy Redhat123
ckpt "sshd is enabled and active"        3 svc_ok sshd
