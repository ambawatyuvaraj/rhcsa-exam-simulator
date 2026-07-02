# Reference solution — SELinux permissive now and on boot

```bash
# Switch to permissive immediately:
setenforce 0

# Persist for the next boot:
sed -i 's/^SELINUX=.*/SELINUX=permissive/' /etc/selinux/config
```

Verify:
```bash
getenforce                              # -> Permissive
grep '^SELINUX=' /etc/selinux/config    # -> SELINUX=permissive
```
