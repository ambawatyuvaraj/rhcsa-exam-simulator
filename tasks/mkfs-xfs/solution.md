# Reference solution — create XFS and mount persistently

Format the spare partition as XFS, then add an fstab entry referencing it by UUID
(stable across device renames) so it mounts automatically on every boot.

> Note: use **any free spare disk**. Run `lsblk` and pick one with no partitions — this solution uses `/dev/vdb`, but substitute yours (e.g. `/dev/vdc`). The grader accepts whichever spare disk you use.

```bash
disk=/dev/vdb        # any free spare disk — check 'lsblk' (could be vdc, vdd, ...)
lsblk                                    # find the partition, e.g. ${disk}1
mkfs.xfs -f ${disk}1
mkdir -p /mnt/<MP>
echo "UUID=$(blkid -s UUID -o value ${disk}1) /mnt/<MP> xfs defaults,nofail 0 0" >>/etc/fstab
mount -a
findmnt /mnt/<MP>        # verify it is mounted
```
