#!/usr/bin/env bash
setenforce 1 >/dev/null 2>&1
sed -i 's/^SELINUX=.*/SELINUX=enforcing/' /etc/selinux/config 2>/dev/null
exit 0
