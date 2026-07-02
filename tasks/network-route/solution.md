# Reference solution — Add a static IPv4 route

```bash
nmcli con modify rhcsart +ipv4.routes "<NET> <GW>"
nmcli con up rhcsart
```
Verify: `nmcli -g ipv4.routes con show rhcsart`.
