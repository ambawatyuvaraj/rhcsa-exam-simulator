# Reference solution — lock a user account

```bash
usermod -L <U>      # or: passwd -l <U>
```

Verify:
```bash
passwd -S <U>       # second field begins with "L" (locked)
```

Notes:
- Locking prepends a `!` to the password hash in /etc/shadow.
- Unlock with `usermod -U <U>` (or `passwd -u <U>`).
