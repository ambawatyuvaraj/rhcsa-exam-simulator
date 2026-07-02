#!/usr/bin/env bash
mkdir -p /opt/ntsrc/sub
# Regular files for each candidate extension.
printf 'x\n' >/opt/ntsrc/app.conf
printf 'x\n' >/opt/ntsrc/sub/db.conf
printf 'x\n' >/opt/ntsrc/system.log
printf 'x\n' >/opt/ntsrc/sub/access.log
printf 'x\n' >/opt/ntsrc/notes.txt
printf 'x\n' >/opt/ntsrc/sub/readme.txt
# A directory whose name ends in each extension — must be excluded.
mkdir -p /opt/ntsrc/trap.conf /opt/ntsrc/trap.log /opt/ntsrc/trap.txt
rm -f "/root/$OUT"
echo "find-name-type: seeded /opt/ntsrc (*.${EXT} -> /root/$OUT)"
exit 0
