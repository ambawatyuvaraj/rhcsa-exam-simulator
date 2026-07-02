#!/usr/bin/env bash
. "$RHCSA_LIB/params.sh"
echo "SB=$(rand_choice httpd_enable_cgi httpd_can_sendmail)"
