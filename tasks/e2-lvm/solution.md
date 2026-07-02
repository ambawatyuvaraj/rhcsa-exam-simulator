# Reference solution — logical volume (VFAT)

This spare disk is shared with the swap task, so **add** a partition (do not
re-label the whole disk). The answer key uses /dev/vdb.

> Note: use the spare disk on this system (run `lsblk`; here it is `/dev/vdb`).

```bash
parted /dev/vdb
   # mkpart myvg  (~810 MiB, e.g. start x  end x+810MiB)
   quit
udevadm settle
vgcreate -s 16M myvg /dev/vdb4          # 16 MiB physical-extent size
lvcreate -l 50 -n mylv myvg            # 50 extents = 800 MiB
mkfs.vfat /dev/myvg/mylv
mkdir /mnt/mydata
echo "UUID=$(blkid -s UUID -o value /dev/myvg/mylv)  /mnt/mydata  vfat  defaults,nofail  0 0" >> /etc/fstab   # nofail = boot won't drop to emergency mode if the device is ever missing
mount -a
lsblk --fs                             # verify /mnt/mydata is mounted (vfat)
```
