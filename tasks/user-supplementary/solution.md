# Reference solution — add a user to supplementary groups

```bash
usermod -aG <G1>,<G2> <U>
```

Verify:
```bash
id <U>      # groups list includes <G1> and <G2>
```

Notes:
- `-a` (append) is essential — `usermod -G` WITHOUT `-a` REPLACES the user's
  secondary groups, removing existing memberships.
