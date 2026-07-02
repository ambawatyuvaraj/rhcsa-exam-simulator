#!/usr/bin/env bash
. "$RHCSA_LIB/params.sh"
echo "SBOOL=$(rand_choice httpd_can_network_connect httpd_enable_homedirs ftpd_full_access nfs_export_all_rw httpd_use_nfs)"
