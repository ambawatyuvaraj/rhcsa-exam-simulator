# Reference solution — logical volume (VFAT)

This spare disk is shared with the swap and resize tasks, so **add** a partition
(do not re-label the whole disk). Partition 1 already holds the existing `myvol`
volume group; the answer key puts myvg on /dev/vdb2 (swap goes on vdb3).

> Note: use the spare disk on this system (run `lsblk`; here it is `/dev/vdb`).

```bash
fdisk /dev/vdb
   # n -> p -> 2 -> <enter> -> +810M     (~810 MiB: 50 x 16 MiB extents + metadata)
   # t -> 2 -> 8e                        (type: Linux LVM)
   # w
udevadm settle
vgcreate -s 16M myvg /dev/vdb2          # 16 MiB physical-extent size
lvcreate -l 50 -n mylv myvg            # 50 extents = 800 MiB
mkfs.vfat /dev/myvg/mylv
mkdir /mnt/mydata
echo "UUID=$(blkid -s UUID -o value /dev/myvg/mylv)  /mnt/mydata  vfat  defaults,nofail  0 0" >> /etc/fstab   # nofail = boot won't drop to emergency mode if the device is ever missing
mount -a
lsblk --fs                             # verify /mnt/mydata is mounted (vfat)
```
