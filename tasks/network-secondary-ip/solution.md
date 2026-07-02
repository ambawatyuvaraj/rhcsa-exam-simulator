# Reference solution — Add a secondary IPv4 address

```bash
nmcli con modify rhcsa2ip +ipv4.addresses <IP>/24
nmcli con up rhcsa2ip
```
Verify: `nmcli -g ipv4.addresses con show rhcsa2ip`.
