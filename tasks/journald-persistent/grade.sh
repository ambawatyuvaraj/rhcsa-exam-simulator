#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
ckpt "journal is persistent" 8 journal_persistent
