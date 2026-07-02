# Reference solution — create a user with a GECOS comment

```bash
useradd -c "<C>" <U>
```

Verify:
```bash
getent passwd <U>      # 5th field is the comment "<C>"
```

Notes:
- `-c` sets the GECOS/comment field. An existing user can be changed with
  `usermod -c "<C>" <U>`.
