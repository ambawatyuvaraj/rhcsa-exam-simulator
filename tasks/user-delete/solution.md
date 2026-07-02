# Reference solution — delete a user and their home directory

```bash
userdel -r <U>
```

Verify:
```bash
id <U>             # "no such user"
ls -d /home/<U>    # "No such file or directory"
```

Notes:
- `-r` removes the home directory and mail spool along with the account.
