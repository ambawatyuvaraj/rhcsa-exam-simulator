# Reference solution — extend a logical volume by 500 MiB

`lvextend -L +500M` grows the LV by 500 MiB; `-r` (--resizefs) grows the
filesystem on top of it in the same step, so the new space is usable and no data
is lost.

```bash
lvextend -r -L +500M /dev/wgroup/wlogic    # +500M and grow the filesystem too
lvs                                         # verify the new size
df -h /mnt/wlogic
```
