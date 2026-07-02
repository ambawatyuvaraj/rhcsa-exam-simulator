# Reference solution — Set IPv4 DNS servers

```bash
nmcli con modify rhcsadns ipv4.dns "<DNS1> <DNS2>"
nmcli con up rhcsadns
```
Verify: `nmcli -g ipv4.dns con show rhcsadns`.
