#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
ckpt "root password is set to '${PW:-redhat123}'"    12 user_password root "${PW:-redhat123}"
