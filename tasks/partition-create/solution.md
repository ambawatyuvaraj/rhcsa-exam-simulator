# Reference solution — create, format and mount a partition

> Note: use **any free spare disk**. Run `lsblk` and pick one with no partitions — this solution uses `/dev/vdb`, but substitute yours (e.g. `/dev/vdc`). The grader accepts whichever spare disk you use.

```bash
disk=/dev/vdb        # any free spare disk — check 'lsblk' (could be vdc, vdd, ...)
lsblk                                   # identify the spare disk, e.g. $disk
parted $disk mklabel gpt             # (only if the disk has no label)
parted $disk mkpart primary 1MiB {{END}}MiB    # END = start 1MiB + ~{{SZ}} MiB
# partition is ${disk}1 (or /dev/vdbp1 on some devices)
mkfs.ext4 -F ${disk}1
mkdir -p /mnt/<MP>
echo "UUID=$(blkid -s UUID -o value ${disk}1) /mnt/<MP> ext4 defaults,nofail 0 0" >>/etc/fstab
mount -a
df -h /mnt/<MP>
```
Note: in this simulator the spare disk may be a loop device (/dev/loopN), whose
first partition is /dev/loopNp1.
