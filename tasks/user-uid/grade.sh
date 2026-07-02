#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"

ckpt "User 'manalo' exists"          3 user_exists manalo
ckpt "manalo has UID 3533"           4 user_uid manalo 3533
ckpt "manalo password is correct"    1 user_password manalo flectrag
