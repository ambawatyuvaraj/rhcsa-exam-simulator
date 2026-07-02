# Reference solution — create a group with a specific GID

```bash
groupadd -g <GID> <G>
```

Verify:
```bash
getent group <G>      # third field is <GID>
```

Notes:
- Change an existing group's GID with `groupmod -g <GID> <G>`.
