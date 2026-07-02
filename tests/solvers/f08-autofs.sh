#!/usr/bin/env bash
dnf install -y nfs-utils autofs >/dev/null 2>&1
systemctl enable --now autofs >/dev/null 2>&1
grep -q '/rhome' /etc/auto.master 2>/dev/null || echo '/rhome  /etc/auto.misc' >> /etc/auto.master
grep -q 'remoteuser1' /etc/auto.misc 2>/dev/null || echo 'remoteuser1  -rw,soft  localhost:/exports/rhome/remoteuser1' >> /etc/auto.misc
systemctl restart autofs >/dev/null 2>&1; sleep 1; ls /rhome/remoteuser1 >/dev/null 2>&1
