#!/usr/bin/env bash
. "$RHCSA_LIB/params.sh"
echo "IMG=$(rand_choice myapp:1 webimg:latest buildimg:v2)"
echo "BD=$(rand_choice /root/buildctx /root/imgbuild)"
