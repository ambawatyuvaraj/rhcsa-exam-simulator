#!/usr/bin/env bash
echo "umask $UM" >/etc/profile.d/rhcsa-umask.sh
chmod 0644 /etc/profile.d/rhcsa-umask.sh
