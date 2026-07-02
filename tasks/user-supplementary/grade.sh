#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
ckpt "User '$U' exists"            2 user_exists "$U"
ckpt "Group '$G1' exists"          1 group_exists "$G1"
ckpt "Group '$G2' exists"          1 group_exists "$G2"
ckpt "$U is in group $G1"          3 user_in_group "$U" "$G1"
ckpt "$U is in group $G2"          3 user_in_group "$U" "$G2"
