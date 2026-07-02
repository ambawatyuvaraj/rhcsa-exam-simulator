# Reference solution — Allow a service through the firewall

```bash
firewall-cmd --permanent --add-service=<FWSVC>
firewall-cmd --reload
```
Verify: `firewall-cmd --list-services` and
`firewall-cmd --permanent --list-services`.
