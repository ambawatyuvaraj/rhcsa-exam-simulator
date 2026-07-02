#!/usr/bin/env bash
nmcli connection modify rhcsa0 ipv4.method manual ipv4.addresses 172.25.250.100/24 ipv4.gateway 172.25.250.254 ipv4.dns 172.25.250.254 connection.autoconnect yes 2>/dev/null
nmcli connection up rhcsa0 >/dev/null 2>&1
hostnamectl set-hostname node1.domain250.example.com 2>/dev/null
