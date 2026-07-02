# Reference solution — reduce LV + ext4 filesystem

The `-r` (--resizefs) flag shrinks the ext4 filesystem first (via resize2fs),
then the logical volume, in one safe step.

```bash
lvreduce -r -y -L 300M /dev/<VG>/<LV>
# (answer 'y' to confirm; with -y it is non-interactive)
df -h /mnt/<MP>
lvs <VG>
```
