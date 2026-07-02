# Reference solution — user with a custom home directory

```bash
useradd -d <HOMEDIR> -m <U>
```

Verify:
```bash
getent passwd <U>      # 6th field is <HOMEDIR>
ls -ld <HOMEDIR>       # directory exists, owned by <U>
```

Notes:
- `-d` sets the home path; `-m` creates it (and copies /etc/skel into it).
