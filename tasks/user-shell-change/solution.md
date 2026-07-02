# Reference solution — change a user's login shell

```bash
usermod -s <SH> <U>
```

Verify:
```bash
getent passwd <U>      # 7th field is the login shell <SH>
```

Notes:
- `chsh -s <SH> <U>` is an equivalent way to change the shell.
