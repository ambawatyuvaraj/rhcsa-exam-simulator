# Reference solution — grow an LV and its XFS filesystem

```bash
lvextend -r -L 512M /dev/<VG>/<LV>      # -r also grows the filesystem
df -h /mnt/<MP>
```
For XFS, `-r` runs `xfs_growfs` after extending the LV (XFS can only grow, not
shrink, and only while mounted).
