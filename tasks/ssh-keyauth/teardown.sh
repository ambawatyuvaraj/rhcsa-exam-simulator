#!/usr/bin/env bash
userdel -rf "$U" >/dev/null 2>&1
rm -f /root/.ssh/id_rhcsa /root/.ssh/id_rhcsa.pub
exit 0
