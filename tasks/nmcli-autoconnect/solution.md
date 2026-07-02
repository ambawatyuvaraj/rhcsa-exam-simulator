# Reference solution — Disable autoconnect

```bash
nmcli con modify rhcsaauto connection.autoconnect no
```
Verify: `nmcli -g connection.autoconnect con show rhcsaauto`.
