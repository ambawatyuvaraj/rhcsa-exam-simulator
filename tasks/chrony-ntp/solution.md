# Reference solution — chrony NTP client

Point the system clock at a specific NTP server: add a `server` line to
/etc/chrony.conf (iburst for a fast first sync), enable chronyd, and verify it is
using that source.

```bash
# Add the NTP server to /etc/chrony.conf:
echo 'server time.example.com iburst' >> /etc/chrony.conf
systemctl enable --now chronyd
chronyc sources -v
```
