# Reference solution — Firewalld rich rule for a source

```bash
firewall-cmd --permanent \
  --add-rich-rule='rule family="ipv4" source address="<FWSRC>" service name="ssh" accept'
firewall-cmd --reload
```
Verify: `firewall-cmd --permanent --list-rich-rules`.
