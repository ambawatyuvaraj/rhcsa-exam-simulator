# Reference solution — add a 512 MiB swap partition

Create a partition, initialise it as swap with `mkswap`, add a persistent
`/etc/fstab` entry so it activates on every boot, then turn it on now.

> Note: use **any free spare disk**. Run `lsblk` and pick one with no partitions — this solution uses `/dev/vdb`, but substitute yours (e.g. `/dev/vdc`). The grader accepts whichever spare disk you use.

```bash
disk=/dev/vdb        # any free spare disk — check 'lsblk' (could be vdc, vdd, ...)
fdisk $disk
   # n  ->  p  ->  1  ->  <enter>  ->  +512M
   # t  ->  82          (Linux swap type)
   # w
mkswap ${disk}1
echo "${disk}1 swap swap defaults,nofail 0 0" >> /etc/fstab    # >> appends (a single > would wipe fstab)
swapon ${disk}1
swapon --show          # confirm the new swap is active
```
