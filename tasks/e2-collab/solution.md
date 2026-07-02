# Reference solution — collaborative (set-GID) directory

The set-GID bit (the leading 2 in `2770`) makes every file created inside inherit
the directory's group, and `770` gives the group full access while shutting out
all other users.

```bash
groupadd -f sysmgrs               # ensure the group exists
mkdir -p /home/managers           # create the directory
chgrp sysmgrs /home/managers      # group ownership = sysmgrs
chmod 2770 /home/managers         # 2=set-GID, 770=rwx owner+group, --- others
ls -ld /home/managers             # drwxrws--- root sysmgrs
```
