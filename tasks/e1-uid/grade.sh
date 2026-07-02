#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"

# No standalone "user exists" checkpoint: the UID check implies existence. The
# env-var task's setup pre-creates alies (without UID 1326), which would otherwise
# leak baseline points here.
ckpt "alies exists with UID 1326"  7 user_uid alies 1326
ckpt "alies password is 123"       3 user_password alies 123
