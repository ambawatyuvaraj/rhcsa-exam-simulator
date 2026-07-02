#!/usr/bin/env bash
touch /etc/security/faillock.conf
sed -i -E '/^[[:space:]]*deny[[:space:]]*=/d' /etc/security/faillock.conf
echo "deny = $N" >> /etc/security/faillock.conf
