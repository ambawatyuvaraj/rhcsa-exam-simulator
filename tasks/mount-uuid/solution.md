# Reference solution — mount persistently by UUID

> Note: use **any free spare disk**. Run `lsblk` and pick one with no partitions — this solution uses `/dev/vdb`, but substitute yours (e.g. `/dev/vdc`). The grader accepts whichever spare disk you use.

```bash
disk=/dev/vdb        # any free spare disk — check 'lsblk' (could be vdc, vdd, ...)
lsblk; blkid                            # find the formatted partition, e.g. ${disk}1
UUID=$(blkid -s UUID -o value ${disk}1)
mkdir -p /mnt/<MP>
echo "UUID=$UUID /mnt/<MP> ext4 defaults,nofail 0 0" >>/etc/fstab
mount -a
findmnt /mnt/<MP>
```
The fstab entry must use `UUID=...` rather than the device path.
