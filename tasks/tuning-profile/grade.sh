#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
ckpt "tuned is enabled (applies at boot)"      4 svc_enabled tuned
ckpt "recommended profile is set as default"   6 tuned_recommended_profile
