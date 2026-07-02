# Reference solution — set an ext4 label in place

> Note: use **any free spare disk**. Run `lsblk` and pick one with no partitions — this solution uses `/dev/vdb`, but substitute yours (e.g. `/dev/vdc`). The grader accepts whichever spare disk you use.

```bash
disk=/dev/vdb        # any free spare disk — check 'lsblk' (could be vdc, vdd, ...)
e2label ${disk}1 <LBL>       # or: tune2fs -L <LBL> ${disk}1
e2label ${disk}1             # verify
```
This changes the label in the existing superblock; the data is untouched.
