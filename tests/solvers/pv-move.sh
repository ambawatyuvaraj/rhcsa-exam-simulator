#!/usr/bin/env bash
. "$RHCSA_LIB/storage-prep.sh"; DEV="$(ensure_spare_disk)"
P2="${DEV}2"; [ -b "$P2" ] || P2="${DEV}p2"
pvmove "$P2" >/dev/null 2>&1
vgreduce "$VG" "$P2" >/dev/null 2>&1
