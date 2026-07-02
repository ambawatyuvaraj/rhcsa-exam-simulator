# Reference solution — Open a TCP port through the firewall

```bash
firewall-cmd --permanent --add-port=<FWPORT>/tcp
firewall-cmd --reload
```
Verify: `firewall-cmd --list-ports` and
`firewall-cmd --permanent --list-ports`.
