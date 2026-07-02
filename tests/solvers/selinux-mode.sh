#!/usr/bin/env bash
# Set SELinux enforcing now and on boot
setenforce 1 >/dev/null 2>&1
sed -i 's/^SELINUX=.*/SELINUX=enforcing/' /etc/selinux/config
