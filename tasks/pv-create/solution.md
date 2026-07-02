# Reference solution — create an LVM physical volume

Partition the spare disk, flag the partition for LVM, then `pvcreate` initialises
it as a physical volume that volume groups can consume.

> Note: use **any free spare disk**. Run `lsblk` and pick one with no partitions — this solution uses `/dev/vdb`, but substitute yours (e.g. `/dev/vdc`). The grader accepts whichever spare disk you use.

```bash
disk=/dev/vdb        # any free spare disk — check 'lsblk' (could be vdc, vdd, ...)
lsblk                                  # find the spare disk, e.g. $disk
parted -s $disk mklabel gpt
parted -s $disk mkpart primary 1MiB 400MiB
parted -s $disk set 1 lvm on        # mark the partition as LVM
pvcreate ${disk}1                      # initialise it as a PV
pvs                                    # verify
```
