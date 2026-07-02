# Reference solution — deny a user access to at

```bash
dnf install -y at                             # /etc/at.deny is honored by atd
systemctl enable --now atd
echo <U> >> /etc/at.deny
```
Verify: `grep -x <U> /etc/at.deny`
