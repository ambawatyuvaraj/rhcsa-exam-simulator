# Reference solution — Enable masquerading

```bash
firewall-cmd --permanent --add-masquerade
firewall-cmd --reload
```
Verify: `firewall-cmd --query-masquerade` and
`firewall-cmd --permanent --query-masquerade`.
