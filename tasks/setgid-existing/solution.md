# Reference solution — set-GID on a shared directory

```bash
chgrp <G> /<DIR>
chmod g+s /<DIR>        # or: chmod 2770 /<DIR>
ls -ld /<DIR>           # mode shows rwxrws---
```
With the set-GID bit, files created in the directory inherit its group rather
than the creator's primary group.
