# Reference solution — two partitions on the spare disk

Create a partition table, then two partitions back-to-back. `parted mkpart` takes
START and END offsets, so partition 1 (~{{A}} MiB) runs 1MiB->{{E1}}MiB and
partition 2 (~{{B}} MiB) runs {{E1}}MiB->{{E2}}MiB. A GPT label is acceptable.

> Note: use **any free spare disk**. Run `lsblk` and pick one with no partitions — this solution uses `/dev/vdb`, but substitute yours (e.g. `/dev/vdc`). The grader accepts whichever spare disk you use.

```bash
disk=/dev/vdb        # any free spare disk — check 'lsblk' (could be vdc, vdd, ...)
lsblk                                    # find the spare disk, e.g. $disk
parted -s $disk mklabel gpt           # write a GPT partition table
parted -s $disk mkpart primary 1MiB {{E1}}MiB        # partition 1, ~{{A}} MiB
parted -s $disk mkpart primary {{E1}}MiB {{E2}}MiB   # partition 2, ~{{B}} MiB
parted -s $disk print                 # confirm both partitions exist
lsblk $disk                           # vdb1 and vdb2 are now listed
```

You do not need to format or mount the partitions.
