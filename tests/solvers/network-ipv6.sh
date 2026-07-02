#!/usr/bin/env bash
# Set a static IPv6 address on the seeded rhcsa6 connection.
nmcli con modify rhcsa6 ipv6.method manual ipv6.addresses "$IP6/64" >/dev/null 2>&1
nmcli con up rhcsa6 >/dev/null 2>&1
