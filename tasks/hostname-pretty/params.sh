#!/usr/bin/env bash
. "$RHCSA_LIB/params.sh"
# Value contains a space, so emit it quoted: the env file is sourced with `. file`.
echo "PH=\"$(rand_choice "Lab Server" "Web Node" "DB Host")\""
