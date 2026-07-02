# Reference solution — Remove a service from the firewall

```bash
firewall-cmd --permanent --remove-service=<SVC>
firewall-cmd --reload
```
Verify: `firewall-cmd --list-services` and
`firewall-cmd --permanent --list-services`.
