# Reference solution — extend a volume group onto a second PV

Grow a VG's capacity by adding another physical volume: make a new partition, turn it
into a PV, then `vgextend` adds it to the VG (raising the PV count and free space).

> Note: use **any free spare disk**. Run `lsblk` and pick one with no partitions — this solution uses `/dev/vdb`, but substitute yours (e.g. `/dev/vdc`). The grader accepts whichever spare disk you use.

```bash
disk=/dev/vdb        # any free spare disk — check 'lsblk' (could be vdc, vdd, ...)
lsblk
parted -s $disk mkpart primary 300MiB 600MiB
pvcreate ${disk}2
vgextend <VG> ${disk}2
vgs <VG>          # verify the PV count is now 2
```
