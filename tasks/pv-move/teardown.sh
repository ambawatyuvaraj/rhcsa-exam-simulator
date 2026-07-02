#!/usr/bin/env bash
. "$RHCSA_LIB/storage-prep.sh"
DEV="$(ensure_spare_disk)"
P1="${DEV}1"; [ -b "$P1" ] || P1="${DEV}p1"
P2="${DEV}2"; [ -b "$P2" ] || P2="${DEV}p2"
vgremove -f "$VG" >/dev/null 2>&1
pvremove -ff -y "$P2" >/dev/null 2>&1
pvremove -ff -y "$P1" >/dev/null 2>&1
spare_cleanup
exit 0
