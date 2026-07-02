# Reference solution — maximum password age

```bash
chage -M <DAYS> <U>
```

Verify:
```bash
chage -l <U>          # "Maximum number of days between password change : <DAYS>"
```

Notes:
- `chage -M <DAYS>` sets the maximum password age.
- Equivalent: `passwd -x <DAYS> <U>`.
