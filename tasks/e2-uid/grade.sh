#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"

# No standalone "user exists" checkpoint: the UID check implies existence. The
# env-var task's setup pre-creates manalo (without UID 3533), which would otherwise
# leak baseline points here.
ckpt "manalo exists with UID 3533"  7 user_uid manalo 3533
ckpt "manalo password is flectrag"  3 user_password manalo flectrag
