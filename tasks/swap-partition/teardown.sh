#!/usr/bin/env bash
. "$RHCSA_LIB/storage-prep.sh"
spare_cleanup
rm -f "$RHCSA_STATE/swap.base" 2>/dev/null
exit 0
