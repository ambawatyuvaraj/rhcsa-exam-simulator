# Reference solution — GPT partition with a name

GPT partitions can carry a name/label (MBR cannot). In `parted`, on a GPT disk the
argument right after `mkpart` is the partition NAME, followed by the start and end.

> Note: use **any free spare disk**. Run `lsblk` and pick one with no partitions — this solution uses `/dev/vdb`, but substitute yours (e.g. `/dev/vdc`). The grader accepts whichever spare disk you use.

```bash
disk=/dev/vdb        # any free spare disk — check 'lsblk' (could be vdc, vdd, ...)
lsblk
parted -s $disk mklabel gpt
parted -s $disk mkpart <PNAME> 1MiB 300MiB   # <PNAME> = the partition name
parted -s $disk print          # the Name column shows <PNAME>
```
