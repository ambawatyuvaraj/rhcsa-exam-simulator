#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"

ckpt "User 'jean' exists"          3 user_exists jean
ckpt "jean has UID 4332"           4 user_uid jean 4332
ckpt "jean password is correct"    1 user_password jean ratencot
