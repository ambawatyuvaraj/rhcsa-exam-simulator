# Reference solution — force a password change at next login

```bash
chage -d 0 <U>      # or: passwd -e <U>
```

Verify:
```bash
chage -l <U>        # "Last password change : password must be changed"
```

Notes:
- This sets the password's last-change date to the epoch (day 0), so it is
  considered expired and must be reset on next login.
