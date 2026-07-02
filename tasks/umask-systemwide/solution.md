# Reference solution — system-wide default umask

Option A — drop-in profile script (recommended):
```bash
echo 'umask <UM>' >/etc/profile.d/rhcsa-umask.sh
chmod 0644 /etc/profile.d/rhcsa-umask.sh
```

Option B — login.defs:
```bash
sed -i 's/^UMASK.*/UMASK           <UM>/' /etc/login.defs
```

Verify:
```bash
grep -r umask /etc/profile.d/ /etc/profile
grep -i '^UMASK' /etc/login.defs
```

Notes:
- A new login session will then use the configured umask (e.g. <UM>).
