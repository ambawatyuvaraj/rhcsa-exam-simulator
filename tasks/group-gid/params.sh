#!/usr/bin/env bash
. "$RHCSA_LIB/params.sh"
echo "G=appgrp$(rand_int 100 999)"
echo "GID=$(rand_int 5000 6000)"
