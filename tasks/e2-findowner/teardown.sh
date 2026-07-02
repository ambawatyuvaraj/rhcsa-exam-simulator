#!/usr/bin/env bash
rm -rf /root/findfiles /opt/sdata /var/tmp/jnotes.log /srv/jacques.cfg 2>/dev/null
userdel -rf jacques >/dev/null 2>&1
exit 0
