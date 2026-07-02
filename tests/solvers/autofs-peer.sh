#!/usr/bin/env bash
id remoteu >/dev/null 2>&1 || useradd -u 4400 -M -d /rhome/remoteu remoteu >/dev/null 2>&1
echo '/rhome  /etc/auto.rhome' >/etc/auto.master.d/rhome.autofs
echo "remoteu  -rw,sync,fstype=nfs4  $PEER_ROLE.example.com:/exports/nodeshare/remoteu" >/etc/auto.rhome
systemctl enable autofs >/dev/null 2>&1; systemctl restart autofs >/dev/null 2>&1
ls /rhome/remoteu >/dev/null 2>&1
