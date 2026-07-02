# Reference solution — labelled swap, referenced by LABEL

Create a swap partition, label it with `mkswap -L`, then reference it in fstab by
`LABEL=` (stable across device renames) so it activates on every boot.

> Note: use **any free spare disk**. Run `lsblk` and pick one with no partitions — this solution uses `/dev/vdb`, but substitute yours (e.g. `/dev/vdc`). The grader accepts whichever spare disk you use.

```bash
disk=/dev/vdb        # any free spare disk — check 'lsblk' (could be vdc, vdd, ...)
lsblk                                   # identify the spare disk, e.g. $disk
parted -s $disk mklabel gpt
parted -s $disk mkpart primary linux-swap 1MiB 300MiB
mkswap -L <LBL> ${disk}1               # format as swap with label <LBL>
echo "LABEL=<LBL> none swap defaults,nofail 0 0" >>/etc/fstab
swapon -a
swapon --show                           # verify the swap is active
```
