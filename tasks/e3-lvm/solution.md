# Reference solution — LVM logical volume

This spare disk is shared with the swap task, so **add** a partition (do not
re-label the whole disk). The answer key uses /dev/vdb, partition 2 (2 GiB,
type Linux LVM).

> Note: use the spare disk on this system (run `lsblk`; here it is `/dev/vdb`).

```bash
fdisk /dev/vdb
   # n -> p -> 2 -> <enter> -> +2G       (new 2 GiB partition)
   # t -> 2 -> 8e                        (type: Linux LVM)
   # w
udevadm settle
pvcreate /dev/vdb2
vgcreate -s 8M datastore /dev/vdb2       # 8 MiB physical-extent size
lvcreate -l 50 -n database datastore     # 50 extents = 400 MiB
mkfs -t ext3 /dev/datastore/database
mkdir -p /mnt/education
echo "UUID=$(blkid -s UUID -o value /dev/datastore/database)  /mnt/education  ext3  defaults,nofail  0 0" >> /etc/fstab   # nofail = boot won't drop to emergency mode if the device is ever missing
mount -a
df -hT                                   # verify /mnt/education is mounted (ext3)
```
