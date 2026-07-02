# Reference solution — volume group + logical volume

The VG needs an 8 MiB extent size (`vgcreate -s 8M`); 100 extents = 800 MiB, so
cut a partition a little larger than that and tag it as Linux LVM (type 8e).

> Note: use **any free spare disk**. Run `lsblk` and pick one with no partitions — this solution uses `/dev/vdb`, but substitute yours (e.g. `/dev/vdc`). The grader accepts whichever spare disk you use.

```bash
disk=/dev/vdb        # any free spare disk — check 'lsblk' (could be vdc, vdd, ...)
fdisk $disk
   # n  ->  p  ->  1  ->  <enter>  ->  +880M
   # t  ->  8e          (Linux LVM)
   # w
pvcreate ${disk}1
vgcreate -s 8M wgroup ${disk}1          # VG 'wgroup', 8 MiB extents
lvcreate -l 100 -n wshare wgroup         # LV 'wshare' = 100 extents (800 MiB)
dnf install -y dosfstools                # provides mkfs.vfat
mkfs.vfat /dev/wgroup/wshare             # vfat filesystem
mkdir -p /mnt/wshare
echo "/dev/wgroup/wshare /mnt/wshare vfat defaults,nofail 0 0" >> /etc/fstab   # nofail = boot won't drop to emergency mode if the device is ever missing
mount -a
```
