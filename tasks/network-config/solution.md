# Reference solution — Static network connection

```bash
nmcli con add type ethernet ifname rhcsa0 con-name rhcsa0 \
      ipv4.method manual \
      ipv4.addresses 172.25.250.100/24 \
      ipv4.gateway 172.25.250.254 \
      ipv4.dns 172.25.250.254 \
      connection.autoconnect yes
nmcli con up rhcsa0
```
Verify: `nmcli con show rhcsa0 | grep ipv4`, `nmcli -g connection.autoconnect con show rhcsa0`.
