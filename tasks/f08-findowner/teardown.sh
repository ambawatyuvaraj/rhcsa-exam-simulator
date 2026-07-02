#!/usr/bin/env bash
rm -rf /root/found /opt/jdata /var/tmp/jnotes.log /srv/simone.cfg 2>/dev/null
userdel -rf simone >/dev/null 2>&1
exit 0
