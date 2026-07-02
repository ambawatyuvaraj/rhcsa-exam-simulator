# Reference solution — copy files under a size into a directory

`-size -5M` selects files smaller than 5 MiB; restrict to regular files so
the directory itself is not copied recursively.

```bash
mkdir -p /home/manage
find /usr/bin -maxdepth 1 -type f -size -5M -exec cp {} /home/manage/ \;
ls /home/manage | wc -l        # verify how many were copied
```
