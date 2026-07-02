#!/usr/bin/env bash
. "$RHCSA_LIB/params.sh"
echo "IP=$(rand_choice 192.168.50.10 10.20.30.40 172.20.5.5)"
echo "HN=$(rand_choice server7.lab.example.com db1.lab.example.com web2.lab.example.com)"
