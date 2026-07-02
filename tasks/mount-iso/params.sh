#!/usr/bin/env bash
. "$RHCSA_LIB/params.sh"
echo "ISO=$(rand_choice repo-snap toolset media-img)"
echo "MP=$(rand_choice isomnt cdrom imgmnt)"
