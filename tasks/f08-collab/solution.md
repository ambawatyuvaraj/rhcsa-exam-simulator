# Reference solution — collaborative (set-GID) directory

The set-GID bit (the leading 2 in `2770`) makes every file created inside inherit
the directory's group, and `770` gives the group full access while shutting out
all other users.

```bash
mkdir -p /home/contrib            # create the directory
chgrp manager /home/contrib       # group ownership = manager
chmod 2770 /home/contrib          # 2=set-GID, 770=rwx owner+group, --- others
ls -ld /home/contrib              # drwxrws--- root manager
```
