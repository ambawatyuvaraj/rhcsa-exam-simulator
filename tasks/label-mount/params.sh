#!/usr/bin/env bash
. "$RHCSA_LIB/params.sh"
echo "LBL=$(rand_choice WORKDATA STORE01 VAULT MEDIA)"
echo "MP=$(rand_choice labeled bylabel lblmnt)"
