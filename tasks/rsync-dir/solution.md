# Reference solution — copy a directory with rsync

`rsync -a` copies recursively while preserving permissions/ownership/timestamps. Note
the trailing-slash rule: NO slash on the source copies the directory itself into the
destination (a slash would copy only its contents).

```bash
dnf install -y rsync                          # rsync is not in a minimal install
rsync -a /opt/rsrc <DEST>/        # copies the rsrc dir into <DEST>
diff -r /opt/rsrc <DEST>/rsrc     # verify the copy matches
```
