# Reference solution — set an account expiration date

```bash
chage -E <DATE> <U>      # e.g. chage -E 2030-12-31 alice42
```

Verify:
```bash
chage -l <U>             # "Account expires : <DATE>"
```

Notes:
- `usermod -e <DATE> <U>` is equivalent.
- Remove an expiry with `chage -E -1 <U>`.
