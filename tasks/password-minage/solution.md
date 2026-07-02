# Reference solution — minimum password age and warning period

```bash
chage -m <MIN> -W 10 <U>
```

Verify:
```bash
chage -l <U>
# "Minimum number of days between password change : <MIN>"
# "Number of days of warning before password expires : 10"
```

Notes:
- `-m` sets the minimum age; `-W` sets the warning period.
- Equivalent: `passwd -n <MIN> -w 10 <U>`.
