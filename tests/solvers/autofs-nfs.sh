#!/usr/bin/env bash
  echo '/rhome /etc/auto.rhome' >/etc/auto.master.d/rhome.autofs
  echo 'remoteuser1 -rw,sync,fstype=nfs4 localhost:/exports/rhome/remoteuser1' >/etc/auto.rhome
  systemctl enable autofs >/dev/null 2>&1; systemctl restart autofs >/dev/null 2>&1; sleep 1; ls /rhome/remoteuser1 >/dev/null 2>&1
