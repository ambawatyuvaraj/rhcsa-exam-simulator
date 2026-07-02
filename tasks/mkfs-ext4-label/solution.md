# Reference solution — labelled ext4, mount by LABEL

> Note: use **any free spare disk**. Run `lsblk` and pick one with no partitions — this solution uses `/dev/vdb`, but substitute yours (e.g. `/dev/vdc`). The grader accepts whichever spare disk you use.

```bash
disk=/dev/vdb        # any free spare disk — check 'lsblk' (could be vdc, vdd, ...)
lsblk                                   # find the partition, e.g. ${disk}1
mkfs.ext4 -L <LBL> ${disk}1            # or: e2label ${disk}1 <LBL>
mkdir -p /mnt/<MP>
echo "LABEL=<LBL> /mnt/<MP> ext4 defaults,nofail 0 0" >>/etc/fstab
mount -a
findmnt /mnt/<MP>
```
The fstab entry must use `LABEL=<LBL>` rather than the device path.
