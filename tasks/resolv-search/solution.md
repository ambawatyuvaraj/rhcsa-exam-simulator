# Reference solution — Set the DNS search domain

```bash
nmcli con modify rhcsasrch ipv4.dns-search <DOM>
nmcli con up rhcsasrch
```
Verify: `nmcli -g ipv4.dns-search con show rhcsasrch`.
