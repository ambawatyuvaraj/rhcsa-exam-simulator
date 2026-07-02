# Reference solution — resilient (nofail) fstab entry

> Note: use **any free spare disk**. Run `lsblk` and pick one with no partitions — this solution uses `/dev/vdb`, but substitute yours (e.g. `/dev/vdc`). The grader accepts whichever spare disk you use.

```bash
disk=/dev/vdb        # any free spare disk — check 'lsblk' (could be vdc, vdd, ...)
mkdir -p /mnt/<MP>
UUID=$(blkid -s UUID -o value ${disk}1)       # the ext4 partition
echo "UUID=$UUID /mnt/<MP> ext4 defaults,nofail 0 0" >>/etc/fstab
mount -a
findmnt /mnt/<MP>
```
`nofail` tells systemd not to fail the boot if the device is absent — useful
for removable or secondary disks.
