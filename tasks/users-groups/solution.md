# Reference solution — Create users, groups and memberships

```bash
groupadd sysmgrs

useradd -G sysmgrs natasha
useradd -G sysmgrs harry
useradd -s /sbin/nologin sarah        # no interactive shell, not in sysmgrs

# Set passwords (either form works):
echo 'flectrags' | passwd --stdin natasha
echo 'flectrags' | passwd --stdin harry
echo 'flectrags' | passwd --stdin sarah
```

Verify:
```bash
id natasha; id harry; id sarah
getent group sysmgrs
getent passwd sarah        # shell must be /sbin/nologin
```

Notes:
- `-G` adds a **secondary** group without changing the primary group.
- `sarah` must NOT appear in `getent group sysmgrs`.
