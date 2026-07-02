# Reference solution — extend an LV and its filesystem

```bash
# Grow the LV and its filesystem in one step:
lvextend -r -L 600M /dev/vgext/lvext
# (-r / --resizefs resizes the ext4/xfs filesystem too)

lvs ; df -h /mnt/lvext
```
For ext4 you can also use `resize2fs`; for XFS use `xfs_growfs` (grow only).
Make sure the VG has enough free extents (`vgs`); the spare disk provides them.
