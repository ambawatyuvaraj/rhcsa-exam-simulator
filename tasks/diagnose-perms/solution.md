# Reference solution — fix permissions so a user can read

```bash
ls -ld /<DIR>            # 700 root:root -> "other" has no access
chmod o+rx /<DIR>        # let others traverse + list the directory
chmod o+r  /<DIR>/file   # let others read the file
runuser -l <U> -c "cat /<DIR>/file"
```
The directory needs both `r` (list) and `x` (traverse) for "other"; each file
also needs `r`. Ownership stays root.
