# Reference solution — Collaborative set-GID directory

```bash
mkdir /home/managers
chgrp sysmgrs /home/managers
chmod 2770 /home/managers      # 2 = set-GID; 770 = rwx for owner+group, none for others
```

Verify:
```bash
ls -ld /home/managers          # drwxrws---  root sysmgrs
```

The leading `2` (set-GID) makes new files inside inherit the `sysmgrs`
group. `chmod g+s` is equivalent for the set-GID bit.
