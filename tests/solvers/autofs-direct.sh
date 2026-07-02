#!/usr/bin/env bash
echo "/-  /etc/auto.direct" >/etc/auto.master.d/direct.autofs
echo "/mnt/$MP  -rw,sync,fstype=nfs4  localhost:/exports/direct" >/etc/auto.direct
systemctl enable autofs >/dev/null 2>&1; systemctl restart autofs >/dev/null 2>&1
ls "/mnt/$MP" >/dev/null 2>&1
