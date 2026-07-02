# Reference solution — Static IPv6 address

```bash
nmcli con modify rhcsa6 ipv6.method manual ipv6.addresses <IP6>/64
nmcli con up rhcsa6
```
Verify: `nmcli -g ipv6.addresses con show rhcsa6`.
