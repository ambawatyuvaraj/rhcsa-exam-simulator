# Reference solution — change a user's primary group

```bash
usermod -g <G> <U>
```

Verify:
```bash
id -gn <U>      # prints <G>
id <U>          # gid=...(<G>)
```

Notes:
- `-g` sets the PRIMARY group (lowercase). `-G` manages secondary groups.
