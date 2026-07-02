# Reference solution — chrony client of a time server

Point chrony at the time server by adding a `server` line to /etc/chrony.conf
(iburst = fast first sync), enable chronyd, and confirm the server is listed.

```bash
dnf -y install chrony
echo 'server node1.example.com iburst' >>/etc/chrony.conf
systemctl enable --now chronyd
chronyc sources           # node1 should appear as a source
```
