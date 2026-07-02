#!/usr/bin/env bash
echo "Defaults timestamp_timeout=$T" > /etc/sudoers.d/rhcsa-timeout
chmod 0440 /etc/sudoers.d/rhcsa-timeout
