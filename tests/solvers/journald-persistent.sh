#!/usr/bin/env bash
mkdir -p /var/log/journal; sed -i "s/^#\?Storage=.*/Storage=persistent/" /etc/systemd/journald.conf; systemctl restart systemd-journald
