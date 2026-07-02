# Reference solution — resize a logical volume

`-r` resizes the filesystem together with the logical volume (ext4 → resize2fs,
XFS → xfs_growfs), so the data is preserved and the space is usable at once.

```bash
lvextend -rL 300M /dev/myvol/vo
   # (or)  lvresize -rL 300M /dev/myvol/vo
lsblk
df -h /mnt/vo          # verify the filesystem grew to ~300 MiB
```
