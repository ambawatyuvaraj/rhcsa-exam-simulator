# Reference solution — swap referenced by UUID

Create and format a swap partition, then reference it in fstab by UUID (stable
across device renames) so it activates on every boot.

> Note: use **any free spare disk**. Run `lsblk` and pick one with no partitions — this solution uses `/dev/vdb`, but substitute yours (e.g. `/dev/vdc`). The grader accepts whichever spare disk you use.

```bash
disk=/dev/vdb        # any free spare disk — check 'lsblk' (could be vdc, vdd, ...)
lsblk
parted -s $disk mklabel gpt
parted -s $disk mkpart primary linux-swap 1MiB 300MiB
mkswap ${disk}1                                            # format as swap (assigns a UUID)
echo "UUID=$(blkid -s UUID -o value ${disk}1) none swap defaults,nofail 0 0" >>/etc/fstab   # persist by UUID
swapon -a
swapon --show                                              # verify it is active
```
