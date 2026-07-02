#!/usr/bin/env bash
dnf install -y nfs-utils autofs >/dev/null 2>&1
systemctl enable --now autofs >/dev/null 2>&1
grep -q '/localhome' /etc/auto.master 2>/dev/null || echo '/localhome  /etc/auto.misc' >> /etc/auto.master
grep -q 'production5' /etc/auto.misc 2>/dev/null || echo 'production5  -rw,soft  localhost:/exports/localhome/production5' >> /etc/auto.misc
systemctl restart autofs >/dev/null 2>&1; sleep 1; ls /localhome/production5 >/dev/null 2>&1
