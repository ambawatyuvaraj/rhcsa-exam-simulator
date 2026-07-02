# Reference solution — VG + LV + vfat + persistent mount

Build the LVM stack bottom-up: partition the disk and mark it a physical volume (PV),
group PVs into a volume group (VG) with a chosen physical-extent size, carve a logical
volume (LV) from the VG, then format and mount it. The fstab line makes the mount
persist across reboots.

> Note: use **any free spare disk**. Run `lsblk` and pick one with no partitions — this solution uses `/dev/vdb`, but substitute yours (e.g. `/dev/vdc`). The grader accepts whichever spare disk you use.

```bash
disk=/dev/vdb        # any free spare disk — check 'lsblk' (could be vdc, vdd, ...)
lsblk
parted -s $disk mklabel gpt
parted -s $disk mkpart primary 1MiB 1024MiB
pvcreate -ff -y ${disk}1                       # initialise the partition as an LVM PV
vgcreate -s 16M myvg ${disk}1           # VG 'myvg', 16 MiB physical extents
lvcreate -y -l 50 -n mylv myvg              # LV 'mylv' = 50 extents
dnf install -y dosfstools                # mkfs.vfat ships in dosfstools
mkfs.vfat /dev/myvg/mylv                 # format vfat
mkdir -p /mnt/mydata
echo "/dev/myvg/mylv /mnt/mydata vfat defaults,nofail 0 0" >>/etc/fstab   # persist the mount
mount -a
```
