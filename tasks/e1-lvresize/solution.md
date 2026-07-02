# Reference solution — resize an LVM logical volume

The `-r` flag resizes the filesystem together with the logical volume, so the
new space is usable immediately and the data is preserved.

```bash
lvresize -l 100 -r /dev/mapper/datastore-database
   # (or, equivalently)
   # lvextend -r -l 100 /dev/datastore/database
lvs
df -hT /mnt/database          # verify the filesystem grew to ~800 MiB
```
