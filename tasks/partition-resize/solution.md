# Reference solution — grow partition + ext4

`parted` will not resize a partition while it is in use, so unmount it first,
grow the partition into the free space, grow the filesystem, then remount.

> Note: use **any free spare disk**. Run `lsblk` and pick one with no partitions — this solution uses `/dev/vdb`, but substitute yours (e.g. `/dev/vdc`). The grader accepts whichever spare disk you use.

```bash
disk=/dev/vdb        # any free spare disk — check 'lsblk' (could be vdc, vdd, ...)
umount /mnt/<MP>
parted -s $disk resizepart 1 400MiB     # grow partition 1 into free space
e2fsck -f ${disk}1
resize2fs ${disk}1                          # grow the ext4 fs to fill it
mount ${disk}1 /mnt/<MP>
df -h /mnt/<MP>
```
Note: on some devices the partition is /dev/vdbp1 / /dev/loopNp1.
