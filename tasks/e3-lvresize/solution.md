# Reference solution — resize an LVM logical volume to 500 MiB

The `-r` flag resizes the filesystem together with the logical volume, so the
new space is usable immediately and the data is preserved. 500 MiB is not a
multiple of the 8 MiB extent size, so LVM rounds up to 504 MiB (63 extents).

```bash
lvresize -L 500M -r /dev/datastore/database
   # (or, equivalently)
   # lvextend -r -L 500M /dev/datastore/database
lvs
df -hT /mnt/education          # verify the filesystem grew to ~500 MiB
```
