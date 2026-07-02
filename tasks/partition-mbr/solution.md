# Reference solution — MBR partition table + primary partition

A brand-new disk has no partition table, so you create the label first. This task
wants an **MSDOS (MBR)** label and one primary partition of about {{SZ}} MiB.
`parted mkpart` takes the partition's START and END offsets (not its size), so a
~{{SZ}} MiB partition starting at 1 MiB ends near {{END}} MiB.

> Note: use **any free spare disk**. Run `lsblk` and pick one with no partitions — this solution uses `/dev/vdb`, but substitute yours (e.g. `/dev/vdc`). The grader accepts whichever spare disk you use.

```bash
disk=/dev/vdb        # any free spare disk — check 'lsblk' (could be vdc, vdd, ...)
lsblk                                    # find the spare disk with no partitions, e.g. $disk
parted -s $disk mklabel msdos         # write an MBR (msdos) partition table
parted -s $disk mkpart primary 1MiB {{END}}MiB   # one primary partition, ~{{SZ}} MiB
parted -s $disk print                 # confirm: "Partition Table: msdos"
lsblk $disk                           # the new partition (vdb1) is now listed
```

You do not need to format or mount the partition for this task.
