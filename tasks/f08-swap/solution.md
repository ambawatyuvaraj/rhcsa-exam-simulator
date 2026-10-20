# Reference solution — add a 512 MiB swap partition

Create a partition, initialise it as swap with `mkswap`, add a persistent
`/etc/fstab` entry so it activates on every boot, then turn it on now.

> Note: the spare disk (`lsblk`; here `/dev/vdb`) already has partition 1 — it holds the
> existing `wgroup` volume group from the resize task. **Add** a new partition; don't
> touch partition 1 or re-label the disk.

```bash
disk=/dev/vdb        # the spare disk — check 'lsblk'
fdisk $disk
   # n  ->  p  ->  2  ->  <enter>  ->  +512M
   # t  ->  2  ->  82   (Linux swap type)
   # w
udevadm settle
mkswap ${disk}2
echo "${disk}2 swap swap defaults,nofail 0 0" >> /etc/fstab    # >> appends (a single > would wipe fstab)
swapon ${disk}2
swapon --show          # confirm the new swap is active
```
