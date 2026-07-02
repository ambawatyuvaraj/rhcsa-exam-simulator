# Reference solution — chrony as a network time server

Make this host serve time to the LAN: `allow` lets the given client network query it,
and `local stratum 10` lets it serve time even when it has no upstream sync. Open the
NTP port in the firewall.

```bash
dnf -y install chrony
grep -q '^allow 192.168.0.0/16' /etc/chrony.conf || echo 'allow 192.168.0.0/16' >>/etc/chrony.conf    # which clients may query us
grep -q '^local stratum 10' /etc/chrony.conf || echo 'local stratum 10' >>/etc/chrony.conf     # serve time even without upstream
systemctl enable --now chronyd
firewall-cmd --add-service=ntp --permanent
firewall-cmd --reload
```
