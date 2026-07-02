#!/usr/bin/env bash
# The task only ever moves the dedicated dummy NIC between zones (never the
# default zone), so cleanup just removes that NIC + its binding.
for z in work home dmz internal public trusted external block drop; do
  firewall-cmd --permanent --zone="$z" --remove-interface=rhcsafw >/dev/null 2>&1
done
systemctl disable --now rhcsa-fwnic.service >/dev/null 2>&1
rm -f /etc/systemd/system/rhcsa-fwnic.service; systemctl daemon-reload >/dev/null 2>&1
ip link del rhcsafw >/dev/null 2>&1
firewall-cmd --reload >/dev/null 2>&1
exit 0
