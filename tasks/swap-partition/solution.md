# Reference solution — add swap

> Note: use **any free spare disk**. Run `lsblk` and pick one with no partitions — this solution uses `/dev/vdb`, but substitute yours (e.g. `/dev/vdc`). The grader accepts whichever spare disk you use.

```bash
disk=/dev/vdb        # any free spare disk — check 'lsblk' (could be vdc, vdd, ...)
lsblk                              # identify the spare disk, e.g. $disk
parted $disk mklabel gpt        # (only if the disk has no label)
parted $disk mkpart primary linux-swap 1MiB 513MiB
mkswap ${disk}1
# add to fstab by UUID:
echo "UUID=$(blkid -s UUID -o value ${disk}1) none swap defaults,nofail 0 0" >>/etc/fstab
swapon -a
swapon --show
```
Note: in this simulator the spare disk may be a loop device (/dev/loopN).
