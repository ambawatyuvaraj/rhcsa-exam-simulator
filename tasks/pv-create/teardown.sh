#!/usr/bin/env bash
. "$RHCSA_LIB/storage-prep.sh"
DEV="$(ensure_spare_disk)"
P="${DEV}1"; [ -b "$P" ] || P="${DEV}p1"
pvremove -ff -y "$P" >/dev/null 2>&1
spare_cleanup
exit 0
