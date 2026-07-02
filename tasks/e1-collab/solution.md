# Reference solution — collaborative (set-GID) directory

The set-GID bit (the leading 2 in `2770`) makes every file created inside inherit
the directory's group, and `770` gives the group full access while shutting out
all other users.

```bash
groupadd -f admin                 # ensure the group exists
mkdir -p /common/admin            # create the directory
chgrp admin /common/admin         # group ownership = admin
chmod 2770 /common/admin          # 2=set-GID, 770=rwx owner+group, --- others
ls -ld /common/admin              # drwxrws--- root admin
```
