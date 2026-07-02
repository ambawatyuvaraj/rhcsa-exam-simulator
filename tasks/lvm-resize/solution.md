# Reference solution — resize a logical volume

```bash
# Grow the LV and its filesystem in one step:
lvextend -r -L 300M /dev/vgroup/vo
# (-r / --resizefs resizes the ext4/xfs filesystem too)

lvs ; df -h /mnt/vo
```
For ext4 you can also use `resize2fs`; for XFS use `xfs_growfs` (grow only).
