#!/usr/bin/env bash
echo "/autohomes  /etc/auto.homes" >/etc/auto.master.d/homes.autofs
echo '*  -rw,sync,fstype=nfs4  localhost:/exports/homes/&' >/etc/auto.homes
systemctl enable autofs >/dev/null 2>&1; systemctl restart autofs >/dev/null 2>&1
ls /autohomes/u1 >/dev/null 2>&1
