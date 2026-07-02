# Reference solution — volume group with a specific PE size

The physical-extent (PE) size is fixed at VG creation with `vgcreate -s <PE>M` and
cannot be changed afterwards; every LV in the VG is allocated in whole PEs.

> Note: use **any free spare disk**. Run `lsblk` and pick one with no partitions — this solution uses `/dev/vdb`, but substitute yours (e.g. `/dev/vdc`). The grader accepts whichever spare disk you use.

```bash
disk=/dev/vdb        # any free spare disk — check 'lsblk' (could be vdc, vdd, ...)
lsblk
parted -s $disk mklabel gpt
parted -s $disk mkpart primary 1MiB 400MiB
pvcreate ${disk}1
vgcreate -s <PE>M <VG> ${disk}1       # create the VG with PE size <PE> MiB
vgdisplay <VG> | grep 'PE Size'        # verify the PE size
```
