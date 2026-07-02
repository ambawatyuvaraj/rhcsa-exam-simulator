# Reference solution — default maximum password age (login.defs)

`PASS_MAX_DAYS` in `/etc/login.defs` is the system-wide default maximum password
age applied to newly created accounts. Edit the line so its value is `20`.

```bash
vi /etc/login.defs
# find the PASS_MAX_DAYS line and set it to:
# PASS_MAX_DAYS   20
```

Equivalent non-interactive edit:

```bash
sed -i -E 's/^[[:space:]]*PASS_MAX_DAYS.*/PASS_MAX_DAYS\t20/' /etc/login.defs
grep -E '^\s*PASS_MAX_DAYS' /etc/login.defs    # verify -> PASS_MAX_DAYS  20
```
