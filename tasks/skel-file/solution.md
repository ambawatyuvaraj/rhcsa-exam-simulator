# Reference solution — default file for new users via /etc/skel

```bash
touch /etc/skel/<F>
```

Verify:
```bash
ls -l /etc/skel/<F>
# New users created afterwards (useradd -m / default) get <F> in their home dir.
```

Notes:
- Files under /etc/skel are copied into a new user's home directory at creation.
- Existing users are unaffected.
