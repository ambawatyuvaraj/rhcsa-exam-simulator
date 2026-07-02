#!/usr/bin/env bash
. "$RHCSA_LIB/params.sh"
# pick a group plus a known representative member package of that group.
# NOTE: group names contain spaces — they MUST be quoted so the generated
# params .env sources correctly (GROUPNAME=Headless Management would otherwise
# set GROUPNAME=Headless and try to run "Management").
case "$(rand_int 1 3)" in
  1) echo 'GROUPNAME="Development Tools"';    echo "MEMBER=make" ;;
  2) echo 'GROUPNAME="Headless Management"';  echo "MEMBER=cockpit-ws" ;;
  3) echo 'GROUPNAME="Container Management"'; echo "MEMBER=buildah" ;;
esac
