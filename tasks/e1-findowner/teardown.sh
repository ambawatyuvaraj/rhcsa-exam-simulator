#!/usr/bin/env bash
rm -rf /root/find.user /opt/sdata /var/tmp/snotes.log /srv/sarah.cfg 2>/dev/null
userdel -rf sarah >/dev/null 2>&1
exit 0
