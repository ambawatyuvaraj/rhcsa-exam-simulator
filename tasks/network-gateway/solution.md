# Reference solution — Set the IPv4 default gateway

```bash
nmcli con modify rhcsagw ipv4.gateway <GW>
nmcli con up rhcsagw
```
Verify: `nmcli -g ipv4.gateway con show rhcsagw`.
