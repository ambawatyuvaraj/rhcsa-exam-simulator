# Reference solution — SELinux enforcing now and on boot

```bash
# Switch to enforcing immediately:
setenforce 1

# Persist for the next boot:
sed -i 's/^SELINUX=.*/SELINUX=enforcing/' /etc/selinux/config
```

Verify:
```bash
getenforce                    # -> Enforcing
grep '^SELINUX=' /etc/selinux/config   # -> SELINUX=enforcing
```
